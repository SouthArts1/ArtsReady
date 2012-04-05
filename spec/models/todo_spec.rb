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
  
  subject { Factory.create(:todo) }
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
  
  it "should know what its next action is" do
    todo = Factory.build(:todo, 
      :answer => Factory.build(:answer, :preparedness => 'unknown'))

    todo.next_action.should == 'Learn About'
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
  
  context ".nearing_due_date" do
    it "should only include incomplete todos" do
      todo = Factory.create(:todo, complete:false)
      Todo.nearing_due_date.should include(todo)
    end
    it "should include overdue todos" do
      todo = Factory.create(:todo, complete:false, due_on: 1.day.ago)
      Todo.nearing_due_date.should include(todo)
    end
    it "should include a todo if its due within 2 days" do
      todo = Factory.create(:todo, complete:false, due_on: 1.day.from_now)
      Todo.nearing_due_date.should include(todo)
      todo = Factory.create(:todo, complete:false, due_on: 2.days.from_now)
      Todo.nearing_due_date.should include(todo)
    end

    it "should exclude complete todos" do
      todo = Factory.create(:todo, complete: true)
      Todo.nearing_due_date.should_not include(todo)
    end
    it "should exclude a todo due in more than 2 days" do
      todo = Factory.create(:todo, complete:false, due_on: 3.days.from_now)
      Todo.nearing_due_date.should_not include(todo)
    end
  end
end
