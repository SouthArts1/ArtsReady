require 'spec_helper'

describe Todo do
  it { should belong_to(:answer) }
  it { should belong_to(:action_item) }
  it { should belong_to(:organization) }
  it { should belong_to(:user) }
  
  it "should accept a due date" do
    todo = Factory.build(:todo)
    todo.due_on.should_not be_nil
  end
  
  it "should allow its user to be changed" do
    todo = Factory.create(:todo)
    todo.user_id = 2
    todo.save.should be_true
  end
  
  it "should allow its priority to be changed" do
    todo = Factory.create(:todo)
    todo.update_attribute(:priority, "non-critical").should be_true
  end
  
end
