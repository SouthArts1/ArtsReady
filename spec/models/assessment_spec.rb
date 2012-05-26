require 'spec_helper'

describe Assessment do
  it {should belong_to(:organization)}
  it {should have_many(:answers)}
  it {should have_many(:todos)}
  
  context "default values" do
    subject { Factory.create(:assessment) }
    it {subject.is_complete?.should be_false} 
    it {subject.percentage_complete.should be_zero} 
  end
  
  describe "#is_complete?" do
    it { Assessment.new(answers_count: 10, completed_answers_count: 0).is_complete?.should be_false }
    it { Assessment.new(answers_count: 10, completed_answers_count: 5).is_complete?.should be_false }
    it { Assessment.new(answers_count: 10, completed_answers_count: 10).is_complete?.should be_true }
  end
  
  describe '#check_complete' do
    it 'records when the last question is answered or skipped' do
      assessment = Factory.create(:assessment)
      assessment.stub(:is_complete?) { false }
      assessment.check_complete
      assessment.completed_at.should be_nil
      
      time = Time.now
      Timecop.freeze(time)
      assessment.stub(:is_complete?) { true }
      assessment.check_complete
      assessment.completed_at.should == time
      
      Timecop.freeze(time + 1.day)
      assessment.stub(:is_complete?) { true }
      assessment.check_complete
      assessment.completed_at.should == time # still
    end
  end
  
  describe '#create_reassessment_todo' do
    let(:completed_at) { Time.now }
    let(:assessment) { Factory.create(:assessment, :completed_at => completed_at) }
    let(:todo) { assessment.create_reassessment_todo }
    subject { todo }
    
    it { should be_a_kind_of Todo }
    it 'tells you what button to press' do
      todo.description.should =~ /Archive and Re-Assess/
    end
    it 'is due one year after the assessment is completed' do
      todo.due_on.should == completed_at.to_date + 1.year
    end
  end
end
