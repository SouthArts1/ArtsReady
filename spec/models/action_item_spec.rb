require 'spec_helper'

describe ActionItem do
  it { should belong_to(:question)}
  it { should have_many(:todos)}
  
  it { should validate_presence_of(:question)}
  it { should validate_presence_of(:description)}
  it { should_not be_valid }
  
  context "#create" do
    it "should be valid with required params" do
      ActionItem.create(:description => 'New Action Item', :question => Factory(:question)).should be_valid
    end
    it "should fail without required params" do
      ActionItem.create(:description => 'New Action Item').should_not be_valid
    end
    it "should fail without required params" do
      ActionItem.create(:question => Factory(:question)).should_not be_valid
    end
    
  end
end
