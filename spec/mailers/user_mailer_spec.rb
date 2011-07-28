require "spec_helper"

describe UserMailer do
  describe "welcome" do
    let(:user) { Factory(:user) }
    let(:mail) { UserMailer.welcome(user) }

    it "renders the headers" do
      mail.subject.should eq("Welcome")
      mail.to.should eq([user.email])
      mail.from.should eq(["no-reply@artsready.org"])
    end

    it "renders the body" do
      mail.body.encoded.should include("Welcome")
    end
  end

end
