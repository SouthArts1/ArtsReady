require 'spec_helper'

describe Organization do

  subject { Factory(:organization) }
  
  it { should have_many(:articles) }
  
  it { should validate_presence_of(:name)} 
  it { should validate_presence_of(:address)} 
  it { should validate_presence_of(:city)} 
  it { should validate_presence_of(:state)} 
  it { should validate_presence_of(:zipcode)}
  
  it {subject.assessment_in_progress?.should be_false} 
  it {subject.assessment_completion.should be_zero} 
  it {subject.todo_completion.should be_zero} 
end
