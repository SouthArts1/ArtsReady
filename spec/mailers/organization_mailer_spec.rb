require "spec_helper"

describe OrganizationMailer do
  describe "sign_up" do
    let(:organization) { Factory.create(:new_organization, :users => [Factory.create(:new_user)]) }
    subject(:mail) { OrganizationMailer.sign_up(organization) }

    it "renders the headers" do
      mail.subject.should eq("Your ArtsReady Profile is Pending Approval")
      mail.to.should eq([organization.users.first.email])
      mail.from.should eq(["admin@artsready.org"])
    end

    it_behaves_like 'a mailer view'
  end

  describe "approved" do
    let(:organization) { Factory.create(:organization, :users => [Factory.create(:user)]) }
    subject(:mail) { OrganizationMailer.approved(organization) }

    it "renders the headers" do
      mail.subject.should eq("#{organization.name} is now part of ArtsReady!")
      mail.to.should eq([organization.users.first.email])
      mail.from.should eq(["admin@artsready.org"])
    end

    it_behaves_like 'a mailer view'
  end

  describe "battle buddy dissolution" do
    let(:target_organization) {
      Factory.create(:organization,
                     :users => [Factory.create(:user)])
    }
    let(:requesting_organization) {
      Factory.create(:organization)
    }
    let(:user) { target_organization.users.first }
    subject(:mail) {
      OrganizationMailer.battle_buddy_dissolution(
        user, target_organization, requesting_organization)
    }

    it_behaves_like 'a mailer view'
  end

  describe "battle buddy invitation" do
    let(:target_organization) {
      Factory.create(:organization,
                     :users => [Factory.create(:user)])
    }
    let(:requesting_organization) {
      Factory.create(:organization)
    }
    let(:user) { target_organization.users.first }
    subject(:mail) {
      OrganizationMailer.battle_buddy_invitation(
        user, target_organization, requesting_organization)
    }

    it_behaves_like 'a mailer view'
  end
end
