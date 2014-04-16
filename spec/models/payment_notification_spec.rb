require 'spec_helper'

describe PaymentNotification do
  describe 'params' do
    it 'is persisted as a hash' do
      params = {'x_param' => 'value'}

      notification = PaymentNotification.create(params: params)

      expect(notification.reload.params).to eq(params)
    end
  end

  describe '#capture?' do
    it 'is true for capture transactions' do
      {
        'AUTH_CAPTURE' => true,
        'AUTH_ONLY' => false,
        'PRIOR_AUTH_CAPTURE' => true,
        'CAPTURE_ONLY' => true,
        'CREDIT' => false,
        'VOID' => false
      }.each do |type, should_capture|
        notification = PaymentNotification.new(params: {'x_type' => type})

        if should_capture
          expect(notification).to be_capture,
            "Expected #{type} to be a capture"
        else
          expect(notification).not_to be_capture,
            "Expected #{type} not to be a capture"
        end
      end
    end
  end

  describe '#success?' do
    it 'is true for approved transactions' do
      {
        '1' => true,
        '2' => false,
        '3' => false,
        '4' => false
      }.each do |response_code, success|
        notification =
          PaymentNotification.new(params: {'x_response_code' => response_code})

        if success
          expect(notification).to be_success,
            "Expected #{response_code} to be a success"
        else
          expect(notification).not_to be_success,
            "Expected #{response_code} not to be a success"
        end
      end
    end
  end

  describe '#subscription' do
    let(:subscription) { double }
    let(:id) { double }
    let(:notification) {
      PaymentNotification.new(params: {'x_subscription_id' => id})
    }

    it 'returns a subscription if one is found' do
      Subscription.should_receive(:find_by_arb_id).
        with(id).
        and_return(subscription)

      expect(notification.subscription).to eq(subscription)
    end

    it 'returns nil if no subscription is found' do
      Subscription.should_receive(:find_by_arb_id).
        with(id).
        and_return(nil)

      expect(notification.subscription).to eq(nil)
    end
  end

  describe 'param methods' do
    specify 'return values from the params hash' do
      notification = PaymentNotification.new(
        params: {'x_company' => 'Company Name'}
      )

      expect(notification.company).to eq('Company Name')
    end

    specify 'do not override existing methods' do
      notification = PaymentNotification.new(
        params: {'x_method' => 'CC'}
      )

      expect { notification.method }.to raise_error(ArgumentError)
    end

    specify 'raise NoMethodError if no param is found' do
      notification = PaymentNotification.new(params: {})

      expect { notification.lajkshda }.to raise_error(NoMethodError)
    end
  end
end
