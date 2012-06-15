require 'spec_helper'

describe Assessment do
  it {should belong_to(:organization)}
  it {should have_many(:answers)}
  it {should have_many(:todos)}
  
  context "default values" do
    subject { Factory.create(:assessment) }
    it {subject.complete?.should be_false} 
    it {subject.percentage_complete.should be_zero} 
  end
  
  describe "#completed?" do
    it { Assessment.new(answers_count: 10, completed_answers_count: 0).should_not be_completed }
    it { Assessment.new(answers_count: 10, completed_answers_count: 5).should_not be_completed }
    it { Assessment.new(answers_count: 10, completed_answers_count: 10).should be_completed }
  end
  
  describe '#check_complete' do
    it 'records when the last question is answered or skipped' do
      assessment = Factory.create(:assessment)
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
    let(:assessment) { Factory.create(:assessment, :completed_at => completed_at) }
    let!(:user) { Factory.create(:user, :organization => assessment.organization) }
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
      too_new = Factory.create(:assessment, :completed_at => 45.weeks.ago)
      already_served = Factory.create(:assessment, :completed_at => 50.weeks.ago)
      already_served.create_reassessment_todo
      in_need = Factory.create(:assessment, :completed_at => 50.weeks.ago)
      in_need_again = Factory.create(:assessment, :completed_at => 100.weeks.ago)
      in_need_again.create_reassessment_todo.
        update_attributes(:complete => true)

      Assessment.pending_reassessment_todo.order(:id).
        should == [in_need, in_need_again]
    end
  end

  describe 'initialize_critical_functions' do
    let(:assessment) { Factory.build(:assessment) }

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
        Factory.create(:completed_assessment, 
                       :organization => assessment.organization, 
                       :has_facilities => true,
                       :has_programs => false,
                       :completed_at => 1.month.ago)

        Factory.create(:completed_assessment, 
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
