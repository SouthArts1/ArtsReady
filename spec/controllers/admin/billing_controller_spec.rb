require 'spec_helper'

describe Admin::BillingController do
  let(:subscription) { double }
  let(:organization) {
    FactoryGirl.build_stubbed(:organization)
  }

  before do
    Organization.stub(:find => organization)
    organization.stub(:subscription => subscription)
    controller.stub(:authenticate_admin! => true)
  end

  describe "edit" do
    before { get :edit, organization_id: 'moot' }

    it { should respond_with :success }
    it 'assigns @subscription' do
      expect(assigns(:subscription)).to eq subscription
    end
  end

  describe "update" do
    let(:valid) { nil }

    before do
      subscription.stub(:update_attributes => valid)

      put :update, organization_id: 'moot',
        subscription: {regular_amount: '300'}
    end

    it 'assigns @subscription' do
      expect(assigns(:subscription)).to eq subscription
    end

    context 'given valid params' do
      let(:valid) { true }

      it { should redirect_to [:admin, organization, :billing] }
    end

    context 'given invalid params' do
      let(:valid) { false }

      it { should render_template 'edit' }
    end
  end
end
