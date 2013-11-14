require 'spec_helper'

describe Assessment do
  it {should belong_to(:organization)}
  it {should have_many(:answers)}
  it {should have_many(:todos)}
  
  context "default values" do
    subject { FactoryGirl.create(:assessment) }
    it {subject.complete?.should be_false} 
    it {subject.percentage_complete.should be_zero} 
  end
  
  describe '#can_skip_section?' do
    let(:assessment) { FactoryGirl.create(:assessment) }
    subject { assessment.can_skip_section?(function) }

    context '(for a required function)' do
      let(:function) { 'people' }
      it { should be_false }
    end

    context '(for an optional function)' do
      let(:function) { 'ticketing' }

      context '(with answered questions)' do
        before do
          FactoryGirl.create(:question, :critical_function => function)
          assessment.answers.for_critical_function(function).first.
            update_attributes(
              :priority => 'critical', :preparedness => 'not ready')
        end

        it { should be_false }
      end

      context '(with no answered questions)' do
        it { should be_true }
      end
    end
  end

  describe 'a new assessment' do
    subject { FactoryGirl.build(:assessment) }
    it { should be_valid }
  end

  describe 'skipping a section' do
    let(:assessment) { FactoryGirl.create(:assessment) }
    subject { assessment }
    before do
      FactoryGirl.create(:question, :critical_function => 'ticketing')
      FactoryGirl.create(:question, :critical_function => 'facilities')
      assessment.answers.for_critical_function('ticketing').
        first.update_attributes(
          :priority => 'critical', :preparedness => 'ready')
    end

    context 'with answered questions' do
      before { assessment.update_section('ticketing', :applicable => false) }
      it { should_not be_valid }
      it { should have(1).error_on(:has_tickets) }
    end

    context 'with no answered questions' do
      before { assessment.update_section('facilities', :applicable => false) }
      it { should be_valid }

      it 'skips all answers in the section' do
        assessment.answers.for_critical_function('facilities').not_skipped.
          should be_empty
      end
    end
  end

  describe 'reconsidering a section' do
    let(:assessment) { FactoryGirl.create(:assessment, :has_facilities => false) }
    subject { assessment }
    before do
      FactoryGirl.create(:question, :critical_function => 'facilities')
    end

    it 'reconsiders all answers in the section' do
      assessment.reload # makes the 'answers' association work right
      assessment.update_section('facilities', :applicable => true).should be_true
      assessment.answers.for_critical_function('facilities').skipped.
        should be_empty
    end
  end

  describe "#completed?" do
    before { 2.times { FactoryGirl.create(:question) } }

    let(:assessment) { FactoryGirl.create(:assessment) }
    let(:first_answer) { assessment.answers.first }
    let(:second_answer) { 
      assessment.answers.where(['id <> ?', first_answer]).last
    }

    it 'should be true if all the questions are answered or skipped' do
      assessment.should_not be_completed

      first_answer.update_attributes(
          :priority => 'critical', :preparedness => 'not ready')
      assessment.reload.should_not be_completed

      second_answer.update_attribute(:was_skipped, true)
      assessment.reload.should be_completed

      second_answer.update_attribute(:was_skipped, false)
      assessment.reload.should_not be_completed

      second_answer.update_attributes(
        :priority => 'critical', :preparedness => 'not ready')
      assessment.reload.should be_completed
    end
  end
  
  describe '#check_complete' do
    it 'records when the last question is answered or skipped' do
      assessment = FactoryGirl.create(:assessment)
      assessment.stub(:completed?) { false }
      assessment.check_complete
      assessment.completed_at.should be_nil
      
      time = Time.now
      Timecop.freeze(time)
      assessment.stub(:completed?) { true }
      assessment.check_complete
      assessment.completed_at.should == time
      
      Timecop.freeze(time + 1.day)
      assessment.stub(:completed?) { true }
      assessment.check_complete
      assessment.completed_at.should == time # still
    end
  end
  
  describe '#create_reassessment_todo' do
    let(:completed_at) { Time.zone.now }
    let(:assessment) { FactoryGirl.create(:assessment, :completed_at => completed_at) }
    let!(:user) { FactoryGirl.create(:user, :organization => assessment.organization) }
    let(:todo) { assessment.create_reassessment_todo }
    subject { todo }
    
    it { should be_a_kind_of Todo }
    it 'tells you what button to press' do
      todo.description.should =~ /repeating your assessment/
    end
    it 'is due one year after the assessment is completed' do
      todo.due_on.should == completed_at.to_date + 1.year
    end

    context 'given an existing todo' do
      let(:existing) { assessment.create_reassessment_todo }

      before do
        existing.update_attributes(:complete => true)
      end

      it 'restarts it' do
        todo.should == existing
        todo.should_not be_complete
        todo.user.should == user
        todo.should_not be_changed
      end
    end
  end
  
  describe '.pending_reassessment_todo' do
    it 'means 11 months since completion and not yet served a reassessment todo' do
      too_new = FactoryGirl.create(:assessment, :completed_at => 45.weeks.ago)
      already_served = FactoryGirl.create(:assessment, :completed_at => 50.weeks.ago)
      already_served.create_reassessment_todo
      in_need = FactoryGirl.create(:assessment, :completed_at => 50.weeks.ago)
      in_need_again = FactoryGirl.create(:assessment, :completed_at => 100.weeks.ago)
      in_need_again.create_reassessment_todo.
        update_attributes(:complete => true)

      Assessment.pending_reassessment_todo.order(:id).
        should == [in_need, in_need_again]
    end
  end

  describe 'initialize_critical_functions' do
    let(:assessment) { FactoryGirl.build(:assessment) }

    context '(given no previous assessments)' do
      it 'uses the default' do
        assessment.initialize_critical_functions

        assessment.should_not have_performances
        assessment.should_not have_tickets
        assessment.should_not have_exhibits
        assessment.should_not have_facilities
        assessment.should_not have_programs
        assessment.should_not have_grants
      end
    end
    context '(given previous assessments)' do
      before do
        FactoryGirl.create(:completed_assessment, 
                       :organization => assessment.organization, 
                       :has_facilities => true,
                       :has_programs => false,
                       :completed_at => 1.month.ago)

        FactoryGirl.create(:completed_assessment, 
                       :organization => assessment.organization, 
                       :has_programs => true,
                       :has_facilities => false,
                       :completed_at => 1.year.ago)
      end
      it 'copies from the latest assessment' do
        assessment.initialize_critical_functions

        assessment.should_not have_programs
        assessment.should have_facilities
      end

    end
  end

end
