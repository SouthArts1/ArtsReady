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

  before do
    PaymentVariable.stub(:float_value).and_return(225.0)
  end

  it_behaves_like 'a subscription'

  describe 'before validation' do
    # Use `new` instead of a factory so that the subscription is a blank
    # slate for `initialize_defaults` to write on.
    let(:subscription) { ProvisionalSubscription.new(organization: org) }

    before { subscription.valid? }

    it 'copies contact data from the organization' do
      expect(subscription.billing_address).to eq(org.address)
      expect(subscription.billing_phone_number).to eq(org.phone_number)
    end
  end

  describe '.payment_method_expires_before?' do
    it 'always returns false' do
      expect(subscription.payment_method_expires_before?(double)).to be_false
    end
  end
end