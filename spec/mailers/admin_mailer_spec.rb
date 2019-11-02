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

  describe 'renewing_organizations_notice' do
    let(:admin_email) { 'adminemail@example.org' }
    let(:renewing_org) {
      FactoryGirl.build_stubbed(:paid_organization,
        name: 'Renewing Org'
      )
    }

    before do
      orgs = [renewing_org]
      orgs.stub(:order).and_return(orgs)
      Organization.stub(:billing_next_month).and_return(orgs)

      User.stub(:admin_emails).and_return([admin_email])
    end

    it 'sends the list to admin@artsready.org' do
      mail = AdminMailer.renewing_organizations_notice

      expect(mail.to).to eq(['admin@artsready.org'])
      expect(mail.subject).to include 'renewing soon'
      expect(mail.body).to include 'Renewing Org'
      expect(mail.body).to include edit_admin_organization_path(renewing_org)
    end
  end

  describe 'credit_card_expiring_organizations_notice' do
    let(:admin_email) { 'adminemail@example.org' }
    let(:expiring_org) {
      FactoryGirl.build_stubbed(:paid_organization,
        name: 'Expiring Org'
      )
    }

    before do
      orgs = [expiring_org]
      orgs.stub(:order).and_return(orgs)
      Organization.stub(:credit_card_expiring_this_month).and_return(orgs)

      User.stub(:admin_emails).and_return([admin_email])
    end

    it 'sends the list to admin@artsready.org' do
      mail = AdminMailer.credit_card_expiring_organizations_notice

      expect(mail.to).to eq(['admin@artsready.org'])
      expect(mail.subject).to include 'expiring soon'
      expect(mail.body).to include 'Expiring Org'
      expect(mail.body).to include edit_admin_organization_path(expiring_org)
    end
  end
end
