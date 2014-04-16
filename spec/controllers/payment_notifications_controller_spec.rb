require 'spec_helper'

describe PaymentNotificationsController do
  describe "POST 'create'" do
    let(:params) { {'x_param' => 'value'} }
    let(:notification) { double }

    before do
      PaymentNotification.
        should_receive(:create).with(params: params).
        and_return(notification)
      PaymentFromNotificationFactory.
        should_receive(:process).with(notification)

      post :create, params
    end

    it 'renders nothing' do
      expect(response.status).to eq 200
    end
  end
end
