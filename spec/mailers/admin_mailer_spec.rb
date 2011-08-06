require "spec_helper"

describe AdminMailer do
  describe "review_public" do
    let(:article) {Factory(:public_article)}
    let(:mail) { AdminMailer.review_public(article) }

    it "renders the headers" do
      admin = Factory(:sysadmin)
      puts User.admins.inspect
      mail.subject.should eq("There is a new public article to review.")
      mail.to.should eq([admin.email])
      mail.from.should eq(["no-reply@artsready.org"])
    end

    it "renders the body" do
      mail.body.encoded.should match("There is a new or edited public article on ArtsReady")
    end
  end

end
