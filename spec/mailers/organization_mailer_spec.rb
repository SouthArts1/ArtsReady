require "spec_helper"

describe OrganizationMailer do
  describe "sign_up" do
    let(:organization) { Factory(:new_organization, :users => [Factory(:new_user)]) }
    let(:mail) { OrganizationMailer.sign_up(organization) }

    it "renders the headers" do
      mail.subject.should eq("Thank you for joining ArtsReady")
      mail.to.should eq([organization.users.first.email])
      mail.from.should eq(["no-reply@artsready.org"])
    end

    it "renders the body" do
    end
  end

  describe "approved" do
    let(:organization) { Factory(:organization, :users => [Factory(:user)]) }
    let(:mail) { OrganizationMailer.approved(organization) }

    it "renders the headers" do
      mail.subject.should eq("Your ArtsReady membership has been approved!")
      mail.to.should eq([organization.users.first.email])
      mail.from.should eq(["no-reply@artsready.org"])
    end

    it "renders the body" do
    end
  end

end
