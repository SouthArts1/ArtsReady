require 'spec_helper'

describe PaymentNotification do
  describe 'params' do
    it 'is persisted as a hash' do
      params = {'x_param' => 'value'}

      notification = PaymentNotification.create(params: params)

      expect(notification.reload.params).to eq(params)
    end
  end
end
