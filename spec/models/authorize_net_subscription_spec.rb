require 'spec_helper'

describe AuthorizeNetSubscription do
  def fake_response(name)
    double(name, :success? => true)
  end

  let(:arb_subscription) { double('ARB subscription') }
  let(:arb_transaction) { double('ARB transaction') }
  let(:arb_id) { 6525121 }
  let(:create_response) { fake_response('create response') }
  let(:cancel_response) { fake_response('cancel response') }
  let(:status_response) { fake_response('status response') }
  let(:card) { double('card') }

  let(:org) { FactoryGirl.build(:organization) }

  subject(:subscription) {
    FactoryGirl.build(:authorize_net_subscription, organization: org)
  }

  let(:blank_subscription) { AuthorizeNetSubscription.new }

  before(:each) do
    AuthorizeNet::ARB::Subscription.stub(:new).and_return(arb_subscription)
    AuthorizeNet::ARB::Transaction.stub(:new).and_return(arb_transaction)
    AuthorizeNet::CreditCard.stub(:new).and_return(card)

    arb_transaction.stub(:set_fields)
    arb_transaction.stub(:set_address)
    arb_transaction.stub(:set_customer)
    arb_subscription.stub(:credit_card=)
    arb_transaction.stub(:create).and_return(create_response)
    arb_transaction.stub(:cancel).and_return(cancel_response)
    arb_transaction.stub(:get_status).and_return(status_response)
    create_response.stub(:subscription_id).and_return(arb_id)
    cancel_response.stub(:message_text)
  end

  it_behaves_like 'a subscription'    # TODO: remove redundant tests from this file

  describe 'number=' do
    it 'removes white space' do
      subscription = blank_subscription
      subscription.number = '5555 5555 5555 4444 '
      expect(subscription.number).not_to match /\s/
    end
  end

  it 'validates expired credit cards' do
    Timecop.freeze(Time.zone.parse('February 23, 2021')) do
      subscription = FactoryGirl.build(:authorize_net_subscription,
        payment_type: 'cc',
        expiry_month: '1',
        expiry_year: '2021'
      )

      subscription.valid?

      expect(subscription.errors.full_messages.join("\n")).
        to include 'expired'
    end
  end

  it 'validates soon-to-expire credit cards on create' do
    Timecop.freeze(Time.zone.parse('January 31, 2022 12:00pm')) do
      subscription = FactoryGirl.build(:authorize_net_subscription,
        payment_type: 'cc',
        expiry_month: '1',
        expiry_year: '2022'
      )

      subscription.valid?

      expect(subscription.errors.full_messages.join("\n")).
        to include 'will expire'
    end
  end

  it 'validates soon-to-expire credit cards on update' do
    Timecop.freeze(Time.zone.parse('November 12, 2021')) do
      subscription = FactoryGirl.build(:authorize_net_subscription,
        start_date: Time.zone.parse('February 1, 2021'),
        payment_type: 'cc',
        expiry_month: '1',
        expiry_year: '2022'
      )

      subscription.valid?

      expect(subscription.errors.full_messages.join("\n")).
        to include 'will expire'
    end
  end

  it 'is not active unless approved by Authorize.Net' do
    create_response.stub(:success?).and_return(false)

    subscription = FactoryGirl.build(:authorize_net_subscription,
      active: false
    )
    subscription.save

    expect(subscription).not_to be_persisted
    expect(subscription).not_to be_active
  end

  context "valid subscription object" do
    before { subscription.save }

    it { should be_persisted }

    it "should create an ARB subscription" do
      expect(subscription.arb_id).to eq arb_id
    end
  end

  context "cancel subscription" do
    before(:each) do
      subscription.save! # so we have something to cancel
    end

    let(:result) { subscription.cancel }

    context 'if Authorize.Net accepts the cancellation' do
      before { cancel_response.stub(:success?).and_return(true) }

      it 'should succeed' do
        expect(result).to be_true
        expect(subscription).not_to be_active
      end
    end

    context 'if Authorize.Net rejects the cancellation' do
      before { cancel_response.stub(:success?).and_return(false) }

      it "should fail" do
        expect(result).to be_false
        expect(subscription).to be_active
      end
    end
  end

  describe 'billing_date_after(time)' do
    let(:start_date) { Date.parse('May 13, 2013') }

    before { subscription.start_date = start_date }

    subject(:next_billing_date) {
      subscription.billing_date_after(time)
    }

    context 'before the subscription begins' do
      let(:time) { start_date - 1.day }

      it 'returns the start date' do
        # relevant if you change payment type before your first charge
        expect(next_billing_date).to eq(start_date)
      end
    end

    context 'the day the subscription begins' do
      let(:time) { start_date }

      it 'returns one year later' do
        expect(next_billing_date).to eq(start_date + 1.year)
      end
    end

    context 'later that year' do
      let(:time) { start_date.end_of_year - 1.day }

      it 'returns one year after the start date' do
        expect(next_billing_date).to eq(start_date + 1.year)
      end
    end

    context 'early next year' do
      let(:time) { start_date.end_of_year + 1.day }

      it 'returns one year after the start date' do
        expect(next_billing_date).to eq(start_date + 1.year)
      end
    end

    context 'late next year' do
      let(:time) { start_date + 1.year + 1.day }

      it 'returns two years after the start date' do
        expect(next_billing_date).to eq(start_date + 2.years)
      end
    end

    context 'four years later' do
      let(:time) { start_date + 4.years + 1.day }

      # Our Authorize.Net subscriptions run 365 days instead of a full
      # year, which matters when a leap year occurs.
      it 'returns 5 * 365 days after the start date' do
        expect(next_billing_date).to eq(start_date + 5 * 365)
        expect(next_billing_date).not_to eq(start_date + 5.years)
      end
    end
  end

  describe 'ARB subscription builders' do
    before do
      AuthorizeNet::ARB::Subscription.
        stub(:new).and_return(arb_subscription)
    end

    describe 'build_subscription_object' do
      let(:subscription) {
        FactoryGirl.build(:authorize_net_subscription,
          organization: org,
          start_date: Time.now,
          starting_amount_in_cents: 5000,
          billing_first_name: 'Fred',
          billing_phone_number: '555-232-2832'
        )
      }
      let(:build_subscription) {
        subscription.send(:build_arb_subscription_for_create)
      }

      it 'builds an ARB subscription' do
        AuthorizeNet::ARB::Subscription.
          should_receive(:new) do |hash|
            expect(hash[:billing_address][:first_name]).
              to eq(subscription.billing_first_name)
            expect(hash[:customer][:phone_number]).
              to eq(subscription.billing_phone_number)
            expect(hash[:start_date]).
              to eq(subscription.start_date)
            expect(hash[:trial_occurrences]).
              to eq(1)
            expect(hash[:trial_amount]).
              to eq(50.0)
            expect(hash).not_to have_key(:subscription_id)
        end

        build_subscription
      end

      it 'returns the ARB subscription' do
        expect(build_subscription).to eq(arb_subscription)
      end
    end

    describe 'build_refresh_subscription_object' do
      let(:subscription) {
        FactoryGirl.build(:authorize_net_subscription,
          organization: org,
          billing_first_name: 'Fred',
          billing_email: 'refresh@test.host'
        )
      }
      let(:build_subscription) {
        subscription.send(:build_arb_subscription_for_replace)
      }

      before do
        org.stub(:next_billing_date).and_return(Date.parse('May 13, 2014'))
        org.stub(:name).and_return('Refresh, Inc.')
      end

      around do |example|
        Timecop.freeze(Time.parse('March 31, 2014')) do
          example.run
        end
      end

      it 'builds an ARB subscription' do
        AuthorizeNet::ARB::Subscription.
          should_receive(:new) do |hash|
          expect(hash[:billing_address][:company]).
            to eq('Refresh, Inc.')
          expect(hash[:customer][:email]).
            to eq(subscription.billing_email)
          expect(hash[:start_date]). # 1 year after original start
            to eq(Time.zone.parse('May 13, 2014'))
          expect(hash).not_to have_key(:subscription_id)
          expect(hash).not_to have_key(:trial_occurrences)
          expect(hash).not_to have_key(:trial_amount)
        end

        build_subscription
      end

      it 'returns the ARB subscription' do
        expect(build_subscription).to eq(arb_subscription)
      end
    end

    describe 'build_subscription_object_for_update' do
      let(:subscription) {
        FactoryGirl.build(:authorize_net_subscription,
          arb_id: 23,
          organization: org,
          billing_zipcode: '94043',
          billing_email: 'update@test.host'
        )
      }
      let(:build_subscription) {
        subscription.send(:build_arb_subscription_for_update)
      }

      it 'builds an ARB subscription' do
        AuthorizeNet::ARB::Subscription.
          should_receive(:new) do |hash|
          expect(hash[:billing_address][:zip]).
            to eq(subscription.billing_zipcode)
          expect(hash[:customer][:email]).
            to eq(subscription.billing_email)
          expect(hash[:subscription_id]).
            to eq(subscription.arb_id)
          expect(hash).not_to have_key(:start_date)
        end

        build_subscription
      end

      it 'returns the ARB subscription' do
        expect(build_subscription).to eq(arb_subscription)
      end
    end
  end

  describe '.payment_method_expires_before?(date)' do
    it 'depends on the expiration date' do
      subscription.attributes = {expiry_month: 12, expiry_year: 2021}
      expect(subscription.payment_method_expires_before?(
        Date.parse('January 1, 2022'))).to be_true
      expect(subscription.payment_method_expires_before?(
        Date.parse('December 31, 2021'))).to be_false
    end
  end

  describe '.credit_card_expiring_this_month' do
    it 'returns subscriptions with credit cards expiring this month' do
      subscriptions = [2, 3, 4].map do |month|
        FactoryGirl.create(:authorize_net_subscription,
          expiry_month: month, expiry_year: 2024,
          organization: FactoryGirl.create(:organization,
            name: "Expiring #{month}/2024")
        )
      end

      Timecop.freeze(Date.parse('March 12, 2024')) do
        expect(Subscription.credit_card_expiring_this_month).
          to eq([subscriptions[1]])
      end
    end
  end

  describe ".get_expiry" do
    around do |example|
      Timecop.freeze(Date.parse('2088-05-23')) { example.run }
    end

    it "defaults to current year" do
      subscription.get_expiry('1', nil).should == "0188"
      subscription.get_expiry('1', '').should == "0188"
    end

    it "defaults to January" do
      subscription.get_expiry(nil, '2089').should == "0189"
      subscription.get_expiry('', '2089').should == "0189"
    end

    it "prepends zero to single-digit month numbers" do
      subscription.get_expiry('1', '2089').should == "0189"
    end

    it "preserves two-digit month numbers" do
      subscription.get_expiry('12', '2089').should == "1289"
    end

    it "accepts four-digit years" do
      subscription.get_expiry('12', '2089').should == "1289"
    end

    it "ignores three-digit years" do
      subscription.get_expiry('12', '089').should == "1288"
    end

    it "ignores two-digit years" do
      subscription.get_expiry('12', '89').should == "1288"
    end

    it "ignores one-digit years" do
      subscription.get_expiry('12', '2').should == "1288"
    end
  end
end
