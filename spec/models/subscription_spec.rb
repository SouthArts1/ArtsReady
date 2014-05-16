require 'spec_helper'

describe Subscription do
  let(:aim_transaction) { double('AIM transaction') }
  let(:arb_subscription) { double('ARB subscription') }
  let(:arb_transaction) { double('ARB transaction') }
  let(:arb_id) { 6525121 }
  let(:arb_response) { double }
  let(:card) { double('card') }

  before(:each) do
    AuthorizeNet::AIM::Transaction.stub(:new).and_return(aim_transaction)
    AuthorizeNet::ARB::Subscription.stub(:new).and_return(arb_subscription)
    AuthorizeNet::ARB::Transaction.stub(:new).and_return(arb_transaction)
    AuthorizeNet::CreditCard.stub(:new).and_return(card)

    aim_transaction.stub(:set_fields)
    aim_transaction.stub(:set_address)
    aim_transaction.stub(:set_customer)
    aim_transaction.stub(:authorize).and_return(double(:success? => true))
    arb_transaction.stub(:set_fields)
    arb_transaction.stub(:set_address)
    arb_transaction.stub(:set_customer)
    arb_transaction.stub(:create).and_return(arb_response)
    arb_response.stub(:success?).and_return(true)
    arb_response.stub(:subscription_id).and_return(arb_id)
    arb_subscription.stub(:credit_card=)
    arb_subscription.stub(:credit_card) # for logging!?
  end

  describe 'number=' do
    it 'removes white space' do
      subscription = Subscription.new
      subscription.number = '5555 5555 5555 4444 '
      expect(subscription.number).not_to match /\s/
    end
  end

  it 'validates expired credit cards' do
    Timecop.freeze(Time.zone.parse('February 23, 2021')) do
      subscription = FactoryGirl.build(:subscription,
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
      subscription = FactoryGirl.build(:subscription,
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
      subscription = FactoryGirl.build(:subscription,
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

  context "invalid subscription object" do
    it "should not save with no attributes" do
      p = Subscription.new()
      expect(p.save).to be_false
    end
    
    it "should not save with only an organization" do
      org = FactoryGirl.create(:organization)
      p = Subscription.new()
      p.organization_id = org.id
      expect(p.save).to be_false
    end
    
    it "should not be active if invalid" do
      p = Subscription.new()
      p.save
      expect(p).not_to be_active
    end

    it "should not be active if it does not save" do
      p = Subscription.create()
      expect(p).not_to be_active
    end
  end
    
  context "valid subscription object" do
    before(:each) do
      @org = FactoryGirl.create(:organization)
      @info_params = {
        regular_amount_in_cents: 100,
        starting_amount_in_cents: 100,
        billing_first_name: "Test",
        billing_last_name: "User",
        billing_address: "123 Awesome St",
        billing_city: "Browntown",
        billing_state: "MO",
        billing_zipcode: "12345",
        billing_email: 'email@example.org',
        organization_id: @org.id
      }
    end
    
    context "credit card" do
      before(:each) do
        @info_params["payment_type"] = "cc"
        @info_params["number"] = "4007000000027"
        @info_params["ccv"] = "123"
        @info_params["expiry_month"] = 10
        @info_params["expiry_year"] = 2020
      end

      it "should validate attributes" do
        p = Subscription.new(@info_params)
        expect(p).to be_valid
      end

      it "should create an ARB subscription" do
        p = Subscription.create(@info_params)
        expect(p.arb_id).to eq arb_id
      end

      it "should be active after create" do
        p = Subscription.create(@info_params)
        expect(p).to be_active
      end
      
      context "get expiry cases" do
        it "should default to current year for passing nil year" do
          p = Subscription.new
          expiry = p.get_expiry(1, nil)
          expiry.should == "01#{Time.now.year.to_s.split("")[2..3].join("")}"
        end
        
        it "should return a valid expiry format if nil is passed for month" do
          p = Subscription.new()
          expiry = p.get_expiry(nil, 2012)
          expiry.should == "0112"
        end
        
        it "should default to current year for passing empty string year" do
          p = Subscription.new
          expiry = p.get_expiry(1, "")
          expiry.should == "01#{Time.now.year.to_s.split("")[2..3].join("")}"
        end
        
        it "should return a valid expiry format if an empty string is passed for month" do
          p = Subscription.new()
          expiry = p.get_expiry("", 2012)
          expiry.should == "0112"
        end
        
        it "should add zero before month number if single digit is passed for month" do
          p = Subscription.new()
          expiry = p.get_expiry(1, 2012)
          expiry.should == "0112"
        end
        
        it "should be properly formatted for two digit months" do
          p = Subscription.new()
          expiry = p.get_expiry(12, 2012)
          expiry.should == "1212"
        end

        it "should be properly formatted for four digit years" do
          p = Subscription.new()
          expiry = p.get_expiry(12, 2012)
          expiry.should == "1212"
        end
        
        it "should be properly formatted for three digit years" do
          p = Subscription.new()
          expiry = p.get_expiry(12, 012)
          expiry.should == "12#{Time.now.year.to_s.split("")[2..3].join("")}"
        end
        
        it "should be properly formatted for two digit years" do
          p = Subscription.new()
          expiry = p.get_expiry(12, 12)
          expiry.should == "12#{Time.now.year.to_s.split("")[2..3].join("")}"
        end
        
        it "should be properly formatted for one digit years" do
          p = Subscription.new()
          expiry = p.get_expiry(12, 2)
          expiry.should == "12#{Time.now.year.to_s.split("")[2..3].join("")}"
        end 
      end
    end

    context "bank account" do
      before(:each) do
        @info_params["payment_type"] = "bank"
        @info_params["routing_number"] = "051404260"
        @info_params["account_number"] = "0000159924689"
        @info_params["bank_name"] = "BBT"
        @info_params["account_type"] = "Checking"

        arb_subscription.stub(:bank_account=)
        arb_subscription.stub(:bank_account)
      end

      it "should validate attributes" do
        p = Subscription.new(@info_params)
        expect(p).to be_valid
      end

      it "should create an ARB subscription" do
        p = Subscription.create(@info_params)
        expect(p.arb_id).to eq arb_id
      end

      it "should be active after create" do
        p = Subscription.create(@info_params)
        expect(p).to be_active
      end
    end
  end
  
  context "cancel subscription" do
    let(:status_response) { double }
    let(:cancel_response) { double }

    before(:each) do
      Subscription.all.each{|p| p.destroy}
      @org = FactoryGirl.create(:organization)
      @info_params = {
        regular_amount_in_cents: 100,
        starting_amount_in_cents: 100,
        billing_first_name: "Test",
        billing_last_name: "User",
        billing_address: "123 Awesome St",
        billing_city: "Browntown",
        billing_state: "MO",
        billing_zipcode: "12345",
        billing_email: 'cancel@example.org',
        organization_id: @org.id
      }
      @info_params["payment_type"] = "cc"
      @info_params["number"] = "4007000000027"
      @info_params["ccv"] = "123"
      @info_params["expiry_month"] = 10
      @info_params["expiry_year"] = 2020

      arb_transaction.stub(:get_status).and_return(status_response)
      arb_transaction.stub(:cancel).and_return(cancel_response)
      status_response.stub(:success?).and_return(true)
      cancel_response.stub(:success?).and_return(true)
      cancel_response.stub(:message_text)
    end
    
    before(:each) do
      @subscription = Subscription.create(@info_params)
      expect(@subscription).to be_persisted
    end

    it "should cancel if created" do
      response = @subscription.cancel
      expect(response).to be_true
      expect(@subscription).not_to be_active
    end
    
    it "should not cancel if Authorize.net refuses" do
      cancel_response.stub(:success?).and_return(false)

      p = Subscription.new(@info_params)
      p.active = true

      response = p.cancel
      expect(response).to be_false
      expect(p).to be_active
    end
  
    it "should update the end_date to today when cancelled" do
      Timecop.freeze(Time.now)

      @subscription.cancel
      expect(@subscription.end_date).to eq Time.now
    end
    
    it "should mark as inactive when cancelled" do
      @subscription.cancel
      expect(@subscription).not_to be_active
    end
  end

  describe 'build_provisional' do
    before do
      Timecop.travel('3400 AD')
    end

    let(:user) { FactoryGirl.build_stubbed(:user, organization: nil) }
    let(:org) {
      FactoryGirl.build_stubbed(:organization,
        users: [user],
        phone_number: '555-020-0384'
      )
    }

    subject(:subscription) { Subscription.build_provisional(organization: org) }

    it { should_not be_persisted }

    it 'has a future expiration date' do
      expect(subscription.expiry_year.to_i).to be > 3400
    end

    it 'copies contact data from the organization' do
      expect(subscription.billing_address).to eq(org.address)
      expect(subscription.billing_phone_number).to eq(org.phone_number)
    end
  end

  describe 'billing_date_after(time)' do
    let(:subscription) {
      FactoryGirl.build(:subscription, start_date: start_date.beginning_of_day)
    }

    let(:start_date) { Date.parse('May 13, 2013') }

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
    let(:org) {
      FactoryGirl.build_stubbed(:organization, name: 'Refresh, Inc.')
    }

    before do
      AuthorizeNet::ARB::Subscription.
        stub(:new).and_return(arb_subscription)
    end

    describe 'build_subscription_object' do
      let(:subscription) {
        FactoryGirl.build(:subscription,
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
        FactoryGirl.build(:subscription,
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
        Timecop.freeze(Time.parse('March 31, 2014'))
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
        FactoryGirl.build(:subscription,
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

  describe '.credit_card_expiring_this_month' do
    it 'returns subscriptions with credit cards expiring this month' do
      subscriptions = [2, 3, 4].map do |month|
        FactoryGirl.create(:subscription,
          expiry_month: month, expiry_year: 2024,
          organization: FactoryGirl.create(:organization,
            name: "Expiring #{month}/2024")
        )
      end

      Timecop.freeze(Date.parse('March 12, 2024'))

      expect(Subscription.credit_card_expiring_this_month).
        to eq([subscriptions[1]])
    end
  end
end
