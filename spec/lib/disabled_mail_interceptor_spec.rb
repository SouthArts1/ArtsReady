require 'spec_helper'

describe DisabledMailInterceptor do
  describe '.deliverable_recipients' do
    it "rejects undeliverable recipients" do
      message = double(to_addrs: ['valid@kosher.com', 'invalid@badtimes.com'])
      User.stub(:send_email_to_address?) do | addr |
        addr == 'valid@kosher.com'
      end

      expect(DisabledMailInterceptor.deliverable_recipients(message)).
        to eq(['valid@kosher.com'])
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

          expect(message.perform_deliveries).to be_truthy
          expect(message.to).to eq(['valid@kosher.com'])
        end
      end
    end
  end
end
