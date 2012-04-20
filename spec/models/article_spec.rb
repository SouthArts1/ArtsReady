require 'spec_helper'

describe Article do
  subject { Article.new }
  
  it { should belong_to(:user) }
  it { should belong_to(:organization) }
  it { should belong_to(:todo) }
  
  it { should validate_presence_of(:title) } 
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:critical_function) }

  it { subject.is_public?.should be_false}
  it { subject.is_featured?.should be_false}
  it { subject.is_disabled?.should be_false}
  it { subject.on_critical_list?.should be_false}

  context "scopes" do
    let(:private_article) { Factory.create(:private_article) }
    let(:public_article) { Factory.create(:public_article) }
    let(:featured_article) { Factory.create(:featured_article) }
    let(:disabled_article) { Factory.create(:disabled_article) }
  
    context "for_public" do
      subject { Article.for_public }

      specify {subject.should include(public_article)}
      specify {subject.should include(featured_article)}
      specify {subject.should_not include(private_article)}
      specify {subject.should_not include(disabled_article)}    
    end

    context "featured" do
      subject { Article.featured }

      specify {subject.should include(featured_article)}
      specify {subject.should_not include(public_article)}
      specify {subject.should_not include(private_article)}
      specify {subject.should_not include(disabled_article)}    
    end
    
  end

  context "recent scope" do

    it "should sort newer articles first" do
      older = Factory.create(:article, :created_at => 1.day.ago)
      newer = Factory.create(:article, :created_at => 1.hour.ago)
      Article.recent.first.should == newer
      Article.recent.should == [newer,older]
    end
    
  end
  
  context 'given a todo' do
    subject { Factory.build(:article, :todo => Factory.create(:todo)) }

    it 'should create a todo note when saved' do
      subject.save!
      subject.todo.todo_notes.all.last.article.should == subject
    end
  end

  context ""
  # scope :recent, order("created_at DESC")
end
