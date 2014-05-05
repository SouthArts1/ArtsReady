require "spec_helper"

describe BillingMailer do
  describe "renewal_receipt" do
    let(:payment) { FactoryGirl.build_stubbed(:payment) }
    let(:recipients) { 'billingemail@example.org' }

    subject(:mail) { BillingMailer.renewal_receipt(payment) }

    before do
      payment.stub(:billing_emails).and_return(recipients)
    end

    it "mails the organization's billing contact(s)" do
      expect(mail.to).to eq [recipients]
    end

    it_behaves_like 'a mailer view'
  end
end
