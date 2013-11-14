require "spec_helper"

describe AdminMailer do
  describe "review_public" do
    let(:article) { FactoryGirl.create(:public_article) }
    let(:admin) { FactoryGirl.create(:sysadmin) }
    let(:mail) { AdminMailer.review_public(article,admin) }

    it "renders the headers" do
      mail.subject.should eq("There is a new public article to review.")
      mail.to.should eq([admin.email])
      mail.from.should eq(["no-reply@artsready.org"])
    end

    it "renders the body" do
      mail.body.encoded.should match("There is a new or edited public article on ArtsReady")
    end

    it_behaves_like 'a mailer view'
  end

end
