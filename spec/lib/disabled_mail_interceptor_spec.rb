require 'spec_helper'

describe DisabledMailInterceptor do
  describe '.deliverable_recipients' do
    it "rejects undeliverable recipients" do
      message = double(to_addrs: ['valid@kosher.com', 'invalid@badtimes.com'],
                      subject: "doesn't matter for this test")
      User.stub(:send_email_to_address?) do | addr |
        addr == 'valid@kosher.com'
      end

      expect(DisabledMailInterceptor.deliverable_recipients(message)).
        to eq(['valid@kosher.com'])
    end

    context "password reset emails" do
      it 'delivers to inactive users' do
        inactive_user = Factory.create(
          :user, :disabled => true, :password_reset_token => "anything")
        inactive_user_mail = UserMailer.password_reset(inactive_user)

        expect(DisabledMailInterceptor.deliverable_recipients(inactive_user_mail)).to include(inactive_user.email)
      end

      it 'delivers to inactive users and organizations' do
        inactive_org = Factory.create(
          :organization, :active => false)
        inactive_org_user = Factory.create(
          :user, :organization => inactive_org, :password_reset_token => "anything")
        inactive_org_mail = UserMailer.password_reset(inactive_org_user)

        expect(DisabledMailInterceptor.deliverable_recipients(inactive_org_mail)).to include(inactive_org_user.email)
      end
    end

    describe 'delivering_email' do
      context 'no deliverable addresses' do
        before do
          DisabledMailInterceptor.stub(deliverable_recipients: [])
        end

        it 'sends no email' do
          message = double()
          message.should_receive(:perform_deliveries=).with(false)

          DisabledMailInterceptor.delivering_email(message)
        end
      end

      context 'some deliverable addresses' do
        before do
          DisabledMailInterceptor.stub(
            deliverable_recipients: ['valid@kosher.com'])
        end

        it 'sends them email' do
          message = Mail.new do
            to ['valid@kosher.com', 'invalid@badtimes.com']
          end

          DisabledMailInterceptor.delivering_email(message)

          expect(message.perform_deliveries).to be_true
          expect(message.to).to eq(['valid@kosher.com'])
        end
      end
    end

  end
end
