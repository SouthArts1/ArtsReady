require 'spec_helper'

describe Answer do
  it { should belong_to(:assessment) }
  it { should belong_to(:question) }
  it { should have_many(:todos) }
  it { should have_many(:action_items).through(:question) }
  
  it { should validate_presence_of(:assessment)}
  it { should validate_presence_of(:question)}
  
  describe '.pending' do
    it 'includes answers that are neither answered nor skipped' do
      answered = FactoryGirl.create(:answered_answer)
      skipped = FactoryGirl.create(:skipped_answer)
      pending = FactoryGirl.create(:pending_answer)
      reconsidered = FactoryGirl.create(:reconsidered_answer)
      Answer.where(['id NOT IN (?)', [answered, skipped, pending, reconsidered]]).destroy_all
      
      Answer.pending.should == [pending, reconsidered]
    end
  end
  
  context "after initial creation" do
    subject { FactoryGirl.create(:answer) }
    
    specify {subject.assessment_id.should_not be_nil}
    specify {subject.question_id.should_not be_nil}
    specify {subject.critical_function.should_not be_blank}
    specify {subject.preparedness.should be_blank}
    specify {subject.priority.should be_blank}
    specify {subject.was_skipped.should be_falsey}
  end
  
  context "valid answer" do
    it "should be valid" do
      answer = FactoryGirl.build(:answer)
      answer.priority='critical'
      answer.preparedness='ready'
      answer.should be_valid
    end
  end
  
  context "with no action items" do
    let(:question) { FactoryGirl.create(:question) }
    it "should not create any todos" do
      Todo.count.should be_zero
    end
  end

  context "with one action item" do
    let(:question) { FactoryGirl.create(:question, :action_items => [FactoryGirl.create(:action_item)]) }
    let(:answer) { FactoryGirl.create(:answer, question: question) }

    it "should create one todo" do
      expect {
        answer.update_attributes(
          :preparedness => 'not ready', :priority => 'critical'
        )
      }.to change { Todo.count }.by(1)
    end
  end
  
  context "status" do

    context "adhoc todo item" do
      # Action Item Created by User: "Not Started"
      it "should have 'not started' status" do
        Todo.create(:description => 'desc', :critical_function => 'crit', :priority => 'priority').status.should == "Not Started"
      end
    end
    
    context "todo from answer" do

      it "should have 'not started' if answer preparedness was unknown" do
        answer = mock_model(Answer, :preparedness => 'unknown')
        todo=Todo.create(:description => 'desc', :critical_function => 'crit', :priority => 'priority', :answer => answer)
        todo.status.should == "Not Started"
      end

      it "should have 'in progress' status if preparedness was ready" do
        answer = mock_model(Answer, :preparedness => 'ready')
        todo=Todo.create(:description => 'desc', :critical_function => 'crit', :priority => 'priority', :answer => answer)
        todo.status.should == "In Progress"
      end

      it "should have 'in progress' status if preparedness was not ready" do
        answer = mock_model(Answer, :preparedness => 'not ready')
        todo=Todo.create(:description => 'desc', :critical_function => 'crit', :priority => 'priority', :answer => answer)
        todo.status.should == "In Progress"
      end

      it "should have 'in progress' status if preparedness was needs work" do
        answer = mock_model(Answer, :preparedness => 'needs work')
        todo=Todo.create(:description => 'desc', :critical_function => 'crit', :priority => 'priority', :answer => answer)
        todo.status.should == "In Progress"
      end
    end
  end
  
end
  
