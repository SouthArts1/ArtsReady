require 'spec_helper'

describe Assessment do
  it {should belong_to(:organization)}
  it {should have_many(:answers)}
  it {should have_many(:todos)}
  
  context "default values" do
    subject {Factory(:assessment)}
    it {subject.is_complete?.should be_false} 
    it {subject.percentage_complete.should be_zero} 
  end
  
end
