require "spec_helper"

describe UserMailer do
  describe "welcome" do
    let(:user) { Factory.create(:user) }
    let(:mail) { UserMailer.welcome(user) }

    it "renders the headers" do
      mail.subject.should eq("Welcome to ArtsReady")
      mail.to.should eq([user.email])
      mail.from.should eq(["admin@artsready.org"])
    end

    it "renders the body" do
      mail.body.encoded.should include("Welcome")
    end

    it_behaves_like 'a mailer view'
  end

  describe "password_reset" do
     let(:user) { Factory.create(:user, :password_reset_token => "anything") }
     let(:mail) { UserMailer.password_reset(user) }

     it "send user password reset url" do
       mail.subject.should eq("Important Information about your ArtsReady Account")
       mail.to.should eq([user.email])
       mail.from.should eq(["admin@artsready.org"])
       mail.body.encoded.should match(edit_password_reset_path(user.password_reset_token))
     end

     it_behaves_like 'a mailer view'
   end
end
