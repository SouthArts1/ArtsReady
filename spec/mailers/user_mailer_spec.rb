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

  describe "password_reset" do
     let(:user) { Factory(:user, :password_reset_token => "anything") }
     let(:mail) { UserMailer.password_reset(user) }

     it "send user password reset url" do
       mail.subject.should eq("Password Reset")
       mail.to.should eq([user.email])
       mail.from.should eq(["no-reply@artsready.org"])
       mail.body.encoded.should match(edit_password_reset_path(user.password_reset_token))
     end
   end
   
end
