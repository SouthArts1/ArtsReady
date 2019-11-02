require "spec_helper"

describe CrisisNotifications do
  describe "announcement" do
    let(:user) { FactoryGirl.create(:user) }
    let(:crisis) { FactoryGirl.create(:crisis) }
    let(:mail) { CrisisNotifications.announcement(user,crisis) }

    it "renders the headers" do
      mail.subject.should eq("ALERT! #{crisis.organization.name} has declared a crisis through ArtsReady!")
      mail.to.should eq([user.email])
      mail.from.should eq(["admin@artsready.org"])
    end

    it_behaves_like 'a mailer view'
  end

  describe "resolved" do
    let(:user) { FactoryGirl.create(:user) }
    let(:crisis) { FactoryGirl.create(:crisis) }
    let(:mail) { CrisisNotifications.resolved(user,crisis) }

    it "renders the headers" do
      mail.subject.should eq("Good news! #{crisis.organization_name} has resolved their crisis through ArtsReady!")
      mail.to.should eq([user.email])
      mail.from.should eq(["admin@artsready.org"])
    end

    it_behaves_like 'a mailer view'
  end

  describe "latest_update" do
    let(:user) { FactoryGirl.create(:user) }
    let(:crisis) { FactoryGirl.create(:crisis) }
    let(:mail) { CrisisNotifications.latest_update(user,crisis,crisis.updates.build(:user => user)) }

    it "renders the headers" do
      mail.subject.should eq("ALERT! #{crisis.organization.name}'s crisis has been updated in ArtsReady!")
      mail.to.should eq([user.email])
      mail.from.should eq(["admin@artsready.org"])
    end

    it_behaves_like 'a mailer view'
  end

end
