require 'spec_helper'

describe TodoNote do
  it { should belong_to(:todo) }
  it { should belong_to(:user) }
  
  context 'given an article' do
    let(:article) { Factory.create(:article) }
    subject { Factory.build(:todo_note, :article => article) }

    it 'should initialize message and user from the article' do
      subject.save!
      subject.user.should == article.user
      subject.message.should == article.title
    end
  end
end
