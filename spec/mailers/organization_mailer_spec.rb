require "spec_helper"

describe OrganizationMailer do
  describe "sign_up" do
    let(:organization) { Factory(:new_organization, :users => [Factory(:new_user)]) }
    let(:mail) { OrganizationMailer.sign_up(organization) }

    it "renders the headers" do
      mail.subject.should eq("Your ArtsReady Profile is Pending Approval")
      mail.to.should eq([organization.users.first.email])
      mail.from.should eq(["admin@artsready.org"])
    end

    it "renders the body" do
    end
  end

  describe "approved" do
    let(:organization) { Factory(:organization, :users => [Factory(:user)]) }
    let(:mail) { OrganizationMailer.approved(organization) }

    it "renders the headers" do
      mail.subject.should eq("#{organization.name} is now part of ArtsReady!")
      mail.to.should eq([organization.users.first.email])
      mail.from.should eq(["admin@artsready.org"])
    end

    it "renders the body" do
    end
  end

end
