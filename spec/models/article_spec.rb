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
    let(:private_article) { FactoryGirl.create(:private_article) }
    let(:public_article) { FactoryGirl.create(:public_article) }
    let(:featured_article) { FactoryGirl.create(:featured_article) }
    let(:disabled_article) { FactoryGirl.create(:disabled_article) }
  
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
    
    context 'visible_to_organization' do
      let(:organization) { FactoryGirl.create(:organization) }

      let!(:public_article) { FactoryGirl.create(:public_article, :title => 'public article') }
      let!(:own_public_article) { FactoryGirl.create(:public_article, :title => 'own public article', :organization => organization) }
      let!(:private_article) { FactoryGirl.create(:private_article, :title => 'private article') }
      let!(:own_private_article) { FactoryGirl.create(:private_article, :title => 'own private article', :organization => organization) }
      let!(:buddies_article) { FactoryGirl.create(:buddies_article, :title => 'buddies article') }
      let!(:own_buddies_article) { FactoryGirl.create(:buddies_article, :title => 'own buddies article', :organization => organization) }
      let!(:allowed_buddies_article) { FactoryGirl.create(:buddies_article, :title => 'allowed buddies article', :organization => FactoryGirl.create(:organization, :battle_buddies => [organization])) }
      let!(:shared_article) { FactoryGirl.create(:shared_article, :title => 'shared article', :buddy_list => "0") }
      let!(:shared_by_article) { FactoryGirl.create(:shared_article, :title => 'shared-by article', :organization => organization, :buddy_list => "0") }
      let!(:shared_with_article) { FactoryGirl.create(:shared_article, :title => 'shared-with article', :buddy_list => organization.id.to_s) }

      subject { Article.visible_to_organization(organization) }

      it 'includes own and shared articles' do
        allowed_buddies_article.organization.battle_buddy_requests.first.accept!
        [
          :public_article, :own_public_article,
          :own_private_article,
          :own_buddies_article, :allowed_buddies_article,
          :shared_by_article, :shared_with_article
        ].each do |article|
          subject.should include(send(article))
        end

        [
          :private_article, :buddies_article, :shared_article 
        ].each do |article|
          subject.should_not include(send(article))
        end
      end
    end

    context 'visible_to_user' do
      context 'for an executive' do
        it 'includes executive articles'
      end

      context 'for a manager' do
        it 'does not include executive articles'
      end
    end

    context 'of_active_orgs' do
      let(:valid_org) { FactoryGirl.create(:organization) }
      let(:valid_user) { FactoryGirl.create(:user, :organization => valid_org) }
      let!(:valid_article) { FactoryGirl.create(:article, :user => valid_user) }

      let(:deactivated_user) {
        FactoryGirl.create(:disabled_user, :organization => valid_org) }
      let!(:deactivated_user_article) {
        FactoryGirl.create(:article, :user => deactivated_user) }

      let(:inactive_org) { FactoryGirl.create(:deactivated_org) }
      let!(:inactive_article) {
        FactoryGirl.create(:article, :organization => inactive_org) }

      it "ignores disabled articles and articles by deactivated orgs" do
        expect(Article.of_active_orgs).to eq([valid_article, deactivated_user_article])
      end
    end
  end

  context "recent scope" do

    it "should sort newer articles first" do
      older = FactoryGirl.create(:article, :created_at => 1.day.ago)
      newer = FactoryGirl.create(:article, :created_at => 1.hour.ago)
      Article.recent.first.should == newer
      Article.recent.should == [newer,older]
    end
    
  end
  
  context 'given a todo' do
    subject { FactoryGirl.build(:article, :todo => FactoryGirl.create(:todo)) }

    it 'should create a todo note when saved' do
      subject.save!
      subject.todo.todo_notes.all.last.article.should == subject
    end
  end

  context ""
  # scope :recent, order("created_at DESC")
end
