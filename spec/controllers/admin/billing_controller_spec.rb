require 'spec_helper'

describe Admin::BillingController do
  let(:organization) {
    FactoryGirl.build_stubbed(:organization)
  }
  let(:subscription) { double(organization: organization) }
  let(:admin) { double('admin') }

  before do
    Organization.stub(:find => organization)
    organization.stub(:subscription => subscription)
    controller.stub(:authenticate_admin! => true)
    controller.stub(:current_user => admin)
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

  describe '#cancel' do
    before do
      subscription.stub(:cancel).and_return(true)

      delete :cancel, organization_id: 'moot'
    end

    it { should redirect_to [:admin, :organizations] }

    it 'cancels the subscription with explanatory metadata' do
      expect(subscription).
        to have_received(:cancel).
        with(role: :admin, canceler: admin)
    end
  end
end
