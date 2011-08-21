require "spec_helper"

describe CrisisNotifications do
  describe "announcement" do
    let(:user) { Factory(:user) }
    let(:crisis) { Factory(:crisis) }
    let(:mail) { CrisisNotifications.announcement(user,crisis) }

    it "renders the headers" do
      mail.subject.should eq("#{crisis.organization.name} declared a crisis!")
      mail.to.should eq([user.email])
      mail.from.should eq(["admin@artsready.org"])
    end

    it "renders the body" do
    end
  end

  describe "resolved" do
    let(:user) { Factory(:user) }
    let(:crisis) { Factory(:crisis) }
    let(:mail) { CrisisNotifications.resolved(user,crisis) }

    it "renders the headers" do
      mail.subject.should eq("#{crisis.organization.name} resolved their crisis!")
      mail.to.should eq([user.email])
      mail.from.should eq(["admin@artsready.org"])
    end

    it "renders the body" do
    end
  end

  describe "latest_update" do
    let(:user) { Factory(:user) }
    let(:crisis) { Factory(:crisis) }
    let(:mail) { CrisisNotifications.latest_update(user,crisis,crisis.updates.build(:user => user)) }

    it "renders the headers" do
      mail.subject.should eq("#{crisis.organization.name} has a crisis update.")
      mail.to.should eq([user.email])
      mail.from.should eq(["admin@artsready.org"])
    end

    it "renders the body" do
    end
  end

end