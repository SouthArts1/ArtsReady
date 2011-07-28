require "spec_helper"

describe OrganizationMailer do
  describe "sign_up" do
    let(:organization) { Factory(:organization) }
    let(:mail) { OrganizationMailer.sign_up(organization) }

    it "renders the headers" do
      mail.subject.should eq("Sign up")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
    end
  end

  describe "approved" do
    let(:organization) { Factory(:organization) }
    let(:mail) { OrganizationMailer.approved(organization) }

    it "renders the headers" do
      mail.subject.should eq("Approved")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
    end
  end

end
