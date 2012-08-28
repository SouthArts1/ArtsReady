require "spec_helper"

describe TodoMailer do
  describe '#reminder' do
    let(:user) { FactoryGirl.create(:user, :email => 'todo@example.com') }
    let(:organization) { user.organization }
    let(:todo) { FactoryGirl.build_stubbed(:todo, :organization => organization) }

    it 'gets a recipient list from the todo' do
      todo.expects(:reminder_recipients).returns([user])
      TodoMailer.expects(:mail).with do |options|
        options[:to] == 'todo@example.com'
      end

      TodoMailer.reminder(todo)
    end
  end
end
