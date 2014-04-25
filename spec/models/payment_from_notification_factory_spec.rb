require 'spec_helper'

describe PaymentFromNotificationFactory do
  subject(:factory) { PaymentFromNotificationFactory.new(notification) }

  let(:eligible_notification) {
    double(
      success?: true,
      capture?: true,
      authenticated?: true,
      subscription: subscription
    )
  }
  let(:subscription) { double(discount_code: 'PASCO', payments: payments) }
  let(:payments) { double }

  describe '.process' do
    context 'given an eligible notification' do
      let(:notification) { eligible_notification }
      let(:payment_date) { 45.minutes.ago }

      before do
        notification.stub(
          created_at: payment_date,
          trans_id: '23876234',
          amount: '300.00',
          account_number: '87263287',
          payment_method: 'ECHECK',
          card_type: ''
        )
      end

      it 'creates a payment' do
        notification.should_receive(:build_payment).with(
          notification: notification,
          subscription: subscription,
          paid_at: payment_date,
          transaction_id: '23876234',
          discount_code: 'PASCO',
          amount: '300.00',
          account_number: '87263287',
          account_type: 'Bank'
        )
        notification.should_receive(:update_attributes).with(
          state: 'processed'
        )

        PaymentFromNotificationFactory.process(notification)
      end
    end

    context 'given any other notification' do
      let(:notification) { eligible_notification }
      before do
        notification.stub(capture?: false)
      end

      it 'does nothing' do
        notification.should_not_receive(:build_payment)
        notification.should_receive(:update_attributes).with(
          state: 'discarded'
        )

        PaymentFromNotificationFactory.process(notification)
      end
    end
  end

  it 'has a notification' do
    notification = double

    expect(PaymentFromNotificationFactory.new(notification).notification).
      to eq(notification)
  end

  describe '#eligible?' do
    let(:notification) {
      eligible_notification
    }

    context 'given a successful subscription capture' do
      it { should be_eligible }
    end

    context 'given an unsuccessful notification' do
      before { notification.stub(:success?).and_return(false) }

      it { should_not be_eligible }
    end

    context 'given an non-capture notification' do
      before { notification.stub(:capture?).and_return(false) }

      it { should_not be_eligible }
    end

    context 'given a notification with no subscription' do
      before { notification.stub(:subscription).and_return(nil) }

      it { should_not be_eligible }
    end

    context 'given a notification with an invalid MD5 hash' do
      before { notification.stub(:authenticated?).and_return(false) }

      it { should_not be_eligible }
    end
  end

  describe '#account_type' do
    context 'given a credit card' do
      let(:notification) {
        double(payment_method: 'CC', card_type: 'Diners Club')
      }

      it 'is the card type' do
        expect(factory.account_type).to eq 'Diners Club'
      end
    end

    context 'given a bank account' do
      let(:notification) {
        double(payment_method: 'ECHECK', card_type: '')
      }

      it 'is "Bank"' do
        expect(factory.account_type).to eq 'Bank'
      end
    end
  end
end
