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

  describe '#authenticated?' do
    let(:notification) {
      notification = PaymentNotification.new(
        params: {
          'x_amount' => '300.00',
          'x_trans_id' => '62352782566'
        }
      )
    }

    before { notification.md5_hash_value = 'hashvalue' }

    it 'is true if the MD5 hash matches' do
      notification.params['x_MD5_Hash'] = '2E15FA8146E3BFDE87B83DEBCE83473F'

      expect(notification).to be_authenticated
    end

    it 'is false if the MD5 hash does not match' do
      notification.params['x_MD5_Hash'] = 'C2DD3D9D4406290640CF833010543979'

      expect(notification).not_to be_authenticated
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
