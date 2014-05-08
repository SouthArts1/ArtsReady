require "spec_helper"

describe BillingMailer do
  describe "renewal_receipt" do
    let(:payment) { FactoryGirl.build_stubbed(:payment) }
    let(:recipients) { 'billingemail@example.org' }
    let(:template) {
      double('template',
        subject: 'renewal receipt subject',
        render: 'rendered body'
      )
    }

    subject(:mail) { BillingMailer.renewal_receipt(payment) }

    before do
      payment.stub(:billing_emails).and_return(recipients)
      Template.stub(:find_usable).and_return(template)
    end

    it "mails the organization's billing contact(s)" do
      expect(mail.to).to eq [recipients]
      expect(mail.subject).to eq 'renewal receipt subject'
      expect(mail.body).to eq 'rendered body'
    end

    it_behaves_like 'a mailer view'
  end
end
