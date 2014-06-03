require 'spec_helper'

describe Payment do
  subject(:payment) { FactoryGirl.build(:payment) }

  it 'has a valid factory' do
    expect(payment).to be_valid
  end

  context 'when saved' do
    let(:payment_date) { Date.today }
    let(:organization) { FactoryGirl.build(:organization) }
    subject(:payment) {
      FactoryGirl.build(:payment,
        paid_at: payment_date,
        organization: organization
      )
    }

    context 'if derived from a notification' do
      before do
        payment.notification = PaymentNotification.new
        organization.stub(:extend_subscription!)
      end

      it "sets the organization's next billing date" do
        organization.should_receive(:extend_subscription!).with()

        payment.save

        expect(payment).to be_persisted
      end
    end

    context 'if entered manually' do
      before { payment.notification = nil }

      context do
        it "does not set the organization's next billing date" do
          organization.should_not_receive(:extend_subscription!)

          payment.save

          expect(payment).to be_persisted
        end
      end

      context 'and extend_subscription is set' do
        before { payment.extend_subscription = true }

        it "sets the organization's next billing date" do
          organization.should_receive(:extend_subscription!).with()

          payment.save

          expect(payment).to be_persisted
        end
      end

    end
  end

  describe 'amount=' do
    it 'handles nil' do
      expect(Payment.new(amount: nil).amount).to be_nil
    end

    it 'handles numbers' do
      expect(Payment.new(amount: 50.24).amount).to eq 50.24
    end

    it 'handles numeric strings' do
      expect(Payment.new(amount: '500.50').amount).to eq 500.50
    end

    it 'handles currency strings' do
      expect(Payment.new(amount: '$75').amount).to eq 75
    end
  end
end
  
