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
  
  subject { FactoryGirl.create(:todo) }
  it {subject.complete?.should be_falsey}
  it {subject.status.should_not == 'Complete'}

  it "should default to 'Work On'" do
    subject.action.should == 'Work On'
  end
  
  it "should accept a due date" do
    todo = FactoryGirl.build(:todo)
    todo.due_on.should_not be_nil
  end
  
  it "should allow its user to be changed" do
    todo = FactoryGirl.create(:todo)
    todo.user_id = 2
    todo.save.should be_truthy
  end
  
  it "should allow its priority to be changed" do
    todo = FactoryGirl.create(:todo)
    todo.update_attribute(:priority, "non-critical").should be_truthy
  end
  
  it "should know what its next action is" do
    todo = FactoryGirl.create(:todo,
      :answer => FactoryGirl.create(:answer, :preparedness => 'unknown'))

    todo.action.should == 'Learn About'
  end
  
  it "should accept being set to complete" do
    todo = FactoryGirl.create(:todo)
    todo.update_attribute(:complete, false).should be_truthy
  end

  it "should set status to 'Complete' when completed" do
    todo = FactoryGirl.create(:todo)
    todo.complete = true
    todo.save
    todo.status.should == 'Complete'
  end
  
  it "should accept a review date" do
    todo = FactoryGirl.build(:todo)
    todo.update_attribute(:review_on, Date.tomorrow).should be_truthy
  end
  
  context ".nearing_due_date" do
    it "should only include incomplete todos" do
      todo = FactoryGirl.create(:todo, complete:false)
      Todo.nearing_due_date.should include(todo)
    end
    it "should include overdue todos" do
      todo = FactoryGirl.create(:todo, complete:false, due_on: Time.zone.today - 1)
      Todo.nearing_due_date.should include(todo)
    end
    it "should include a todo if its due within 2 days" do
      todo = FactoryGirl.create(:todo, complete:false, due_on: Time.zone.today + 1)
      Todo.nearing_due_date.should include(todo)
      todo = FactoryGirl.create(:todo, complete:false, due_on: Time.zone.today + 2)
      Todo.nearing_due_date.should include(todo)
    end

    it "should exclude complete todos" do
      todo = FactoryGirl.create(:todo, complete: true)
      Todo.nearing_due_date.should_not include(todo)
    end
    it "should exclude a todo due in more than 2 days" do
      todo = FactoryGirl.create(:todo, complete:false, due_on: Time.zone.today + 3)
      Todo.nearing_due_date.should_not include(todo)
    end
  end

  describe '.create_or_restart' do
    context 'given no matching todo item' do
      it 'creates a new one' do
        count = Todo.count
        todo = Todo.create_or_restart(
          FactoryGirl.attributes_for(:todo).merge(
            :organization => FactoryGirl.create(:organization),
            :action_item => FactoryGirl.create(:action_item)))
        Todo.count.should == count + 1
      end
    end

    context 'given a matching todo item' do
      let(:existing) {
        FactoryGirl.create(:todo,
          :organization => FactoryGirl.create(:organization),
          :action_item => FactoryGirl.create(:action_item))
      }

      it 'restart it' do
        todo = Todo.create_or_restart(
          :organization => existing.organization,
          :action_item => existing.action_item)
        todo.should == existing
      end
    end
  end

  describe '.restart' do
    let(:todo) {
      FactoryGirl.create(:todo,
        :action => 'Review',
        :complete => true,
        :due_on => 6.months.ago)
    }

    before do
      answer = FactoryGirl.create(:answer,
                              :preparedness => 'unknown')
      todo.restart(:answer => answer)
    end

    it 'saves the changes' do
      todo.should_not be_changed
    end

    it 'resets default attributes' do
      todo.should_not be_complete
      todo.due_on.should be_nil
    end

    it 'updates provided attributes' do
      todo.action.should == 'Learn About'
    end

    it 'adds a note' do
      todo.todo_notes.order('id ASC').last.message.should =~ /restart/i
    end
  end

  describe '.reminder_recipients' do
    context '(assigned)' do
      let(:user) { FactoryGirl.build(:user) }
      let(:todo) { FactoryGirl.build(:todo, :user => user) }
      it 'returns the assigned user' do
        todo.reminder_recipients.should == [user]
      end
    end

    context '(unassigned)' do
      let(:manager) { FactoryGirl.create(:manager) }
      let(:organization) { manager.organization }
      let(:todo) { FactoryGirl.build(:todo, :organization => organization) }
      it "returns the organization's manager(s)" do
        todo.reminder_recipients.should == [manager]
      end
    end
  end
end
