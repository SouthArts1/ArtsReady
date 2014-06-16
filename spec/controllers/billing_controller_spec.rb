require 'spec_helper'

describe BillingController do
  before { sign_in_as user }

  describe '#cancel' do
    let(:subscription) {
      FactoryGirl.build_stubbed(:authorize_net_subscription,
        organization: user.organization
      )
    }

    let(:user) { FactoryGirl.build_stubbed(:executive) }

    before do
      user.organization.stub(:subscription).and_return(subscription)
      subscription.stub(:cancel).and_return(true)

      delete :cancel
    end

    it { should redirect_to :root }

    it 'cancels the subscription with explanatory metadata' do
      expect(subscription).
        to have_received(:cancel).
          with(role: :organization, canceler: user)
    end
  end
end
