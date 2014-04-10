require 'spec_helper'

describe PaymentNotificationsController do
  describe "POST 'create'" do
    let(:params) { {'x_param' => 'value'} }

    before do
      PaymentNotification.should_receive(:create).with(params: params)

      post :create, params
    end

    it 'renders nothing' do
      expect(response.status).to eq 200
    end
  end
end
