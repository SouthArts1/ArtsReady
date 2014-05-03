require "spec_helper"

describe AdminMailer do
  describe "review_public" do
    let(:article) { Factory.create(:public_article) }
    let(:admin) { Factory.create(:sysadmin) }
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

  describe 'renewing_organizations_notice' do
    let(:admin_email) { 'adminemail@example.org' }
    let(:renewing_org) {
      FactoryGirl.build_stubbed(:renewing_organization,
        name: 'Renewing Org'
      )
    }

    before do
      orgs = [renewing_org]
      orgs.stub(:order).and_return(orgs)
      Organization.stub(:billing_this_month).and_return(orgs)

      User.stub(:admin_emails).and_return([admin_email])
    end

    it 'sends the list to admins' do
      mail = AdminMailer.renewing_organizations_notice

      mail.to.should eq([admin_email])
      mail.subject.should include 'renewing soon'
      mail.body.should include 'Renewing Org'
    end
  end
end
