require 'spec_helper'

describe Payment do
  subject(:payment) { FactoryGirl.build(:payment) }

  it 'has a valid factory' do
    expect(payment).to be_valid
  end

  context 'when saved' do
    let(:subscription_event) {
      FactoryGirl.build_stubbed(:subscription_event)
    }

    subject(:payment) {
      FactoryGirl.build(:payment,
        subscription_event: subscription_event
      )
    }

    context 'if derived from a notification' do
      before do
        payment.notification = PaymentNotification.new
        subscription_event.stub(:extend_next_billing_date!)
      end

      context '(successful)' do
        before { payment.notification.stub(:success? => true) }

        it "sets the organization's next billing date" do
          subscription_event.should_receive(:extend_next_billing_date!).with(no_args)

          payment.save

          expect(payment).to be_persisted
        end
      end

      context '(unsuccessful)' do
        before { payment.notification.stub(:success? => false) }

        it "does not the organization's next billing date" do
          subscription_event.should_not_receive(:extend_next_billing_date!)

          payment.save

          expect(payment).to be_persisted
        end
      end
    end

    context 'if entered manually' do
      before { payment.notification = nil }

      context do
        it "does not set the organization's next billing date" do
          subscription_event.should_not_receive(:extend_next_billing_date!)

          payment.save

          expect(payment).to be_persisted
        end
      end

      context 'and extend_subscription is set' do
        before { payment.extend_subscription = true }

        it "sets the organization's next billing date" do
          subscription_event.should_receive(:extend_next_billing_date!).with(no_args)

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
  
