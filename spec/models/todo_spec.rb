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

  it "should default to 'Work On'" do
    subject.action.should == 'Work On'
  end
  
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
    todo = Factory.create(:todo, 
      :answer => Factory.create(:answer, :preparedness => 'unknown'))

    todo.action.should == 'Learn About'
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

  describe '.create_or_reset' do
    context 'given no matching todo item' do
      it 'creates a new one' do
        count = Todo.count
        todo = Todo.create_or_reset(
          Factory.attributes_for(:todo).merge(
            :organization => Factory.create(:organization),
            :action_item => Factory.create(:action_item)))
        Todo.count.should == count + 1
      end
    end

    context 'given a matching todo item' do
      let(:existing) {
        Factory.create(:todo,
          :organization => Factory.create(:organization),
          :action_item => Factory.create(:action_item))
      }

      it 'resets it' do
        todo = Todo.create_or_reset(
          :organization => existing.organization,
          :action_item => existing.action_item)
        todo.should == existing
      end
    end
  end

  describe '.reset' do
    let(:todo) {
      Factory.create(:todo,
        :action => 'Review',
        :complete => true,
        :due_on => 6.months.ago)
    }

    before do
      todo.reset(:action => 'Work On')
    end

    it 'saves the changes' do
      todo.should_not be_changed
    end

    it 'resets default attributes' do
      todo.should_not be_complete
      todo.due_on.should be_nil
    end

    it 'updates provided attributes' do
      todo.action.should == 'Work On'
    end

    it 'adds a note' do
      todo.todo_notes.order('id ASC').last.message.should =~ /reset/i
    end
  end
end
