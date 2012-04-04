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
  
  context "#is_complete?" do
    it { Assessment.new(answers_count: 10, completed_answers_count: 0).is_complete?.should be_false }
    it { Assessment.new(answers_count: 10, completed_answers_count: 5).is_complete?.should be_false }
    it { Assessment.new(answers_count: 10, completed_answers_count: 10).is_complete?.should be_true }
  end
  
end
