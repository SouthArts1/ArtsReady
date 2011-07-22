require 'spec_helper'

describe Todo do
  it { should belong_to(:answer) }
  it { should belong_to(:action_item) }
  it { should belong_to(:organization) }
  it { should belong_to(:user) }
  it { should have_many(:articles) }
  it { should have_many(:todo_notes) }

  it { should validate_presence_of(:critical_function)}
  it { should validate_presence_of(:description)}
  it { should validate_presence_of(:priority)}
  
  subject { Factory(:todo) }
  it {subject.complete?.should be_false}
  it {subject.status.should_not == 'Complete'}
  
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
  
  it "should accept being set to complete" do
    todo = Factory.create(:todo)
    todo.update_attribute(:complete, false).should be_true
  end

  it "should set status to 'Complete' when completed" do
    todo = Factory.create(:todo)
    todo.complete = true
    todo.save
    todo.status.should == 'Complete'
  end
  
  it "should accept a review date" do
    todo = Factory.build(:todo)
    todo.update_attribute(:review_on, Date.new).should be_true
  end
  
end
