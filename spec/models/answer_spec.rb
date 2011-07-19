require 'spec_helper'

describe Answer do
  it { should belong_to(:assessment) }
  it { should belong_to(:question) }
  it { should have_many(:todos) }
  it { should have_many(:action_items).through(:question) }
  
  it { should validate_presence_of(:assessment)}
  it { should validate_presence_of(:question)}
  # it { should validate_presence_of(:preparedness)}
  # it { should validate_presence_of(:priority)}
  
  
  context "with no action items" do
    let(:question) { Factory(:question) }
    it "should not create any todos" do
      Todo.count.should be_zero
    end
  end

  context "with one action item" do
    let(:question) { Factory(:question, :action_items => [Factory(:action_item)]) }
    it "should create one todo" do
      pending
      expect {Answer.create(:preparedness => 'not ready', :priority => 'critical', :organization => Factory(:organization), :question => question) }.to change { Todo.count }.by(1)
    end
  end
  
end
