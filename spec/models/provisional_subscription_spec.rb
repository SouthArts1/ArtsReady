require 'spec_helper'

describe 'ProvisionalSubscription' do
  let(:user) { FactoryGirl.build(:user, organization: nil) }
  let(:org) {
    FactoryGirl.build(:organization,
      users: [user],
      phone_number: '555-020-0384'
    )
  }

  subject(:subscription) {
    FactoryGirl.build(:provisional_subscription, organization: org)
  }

  it_behaves_like 'a subscription'

  describe 'before validation' do
    before { subscription.valid? }

    it 'copies contact data from the organization' do
      expect(subscription.billing_address).to eq(org.address)
      expect(subscription.billing_phone_number).to eq(org.phone_number)
    end
  end
end