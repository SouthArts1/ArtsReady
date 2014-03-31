require 'spec_helper'

describe Payment do
  context "invalid payment object" do
    it "should not save with no attributes" do
      p = Payment.new()
      p.save.should == false
    end
    
    it "should not save with only an organization" do
      org = FactoryGirl.create(:organization)
      p = Payment.new()
      p.organization_id = org.id
      p.save.should == false
    end
    
    it "should not be active if invalid" do
      p = Payment.new()
      p.save
      p.is_active? == false
    end
    
    it "should not be active if it does not save" do
      p = Payment.create()
      p.is_active? == false
    end
    
    it "should show 0 days left before rebill if invalid" do
      p = Payment.create()
      p.days_left_until_rebill == 0
    end
  end
    
  context "valid payment object" do
    before(:all) do
      @org = FactoryGirl.build_stubbed(:organization)
      @info_params = {
        regular_amount_in_cents: 100,
        starting_amount_in_cents: 100,
        billing_first_name: "Test",
        billing_last_name: "User",
        billing_address: "123 Awesome St",
        billing_city: "Browntown",
        billing_state: "MO",
        billing_zipcode: "12345",
        organization_id: @org.id
      }
    end
    
    context "credit card" do
      before(:all) do
        @info_params["payment_type"] = "cc"
        @info_params["number"] = "4007000000027"
        @info_params["ccv"] = "123"
        @info_params["expiry_month"] = 10
        @info_params["expiry_year"] = 2020
      end

      it "should validate attributes" do
        p = Payment.new(@info_params)
        p.valid? == true
      end

      it "should create an ARB subscription" do
        p = Payment.create(@info_params)
        p.arb_id.nil? == false
      end

      it "should be active after create" do
        p = Payment.create(@info_params)
        p.is_active? == true
      end
      
      context "get expiry cases" do
        it "should default to current year for passing nil year" do
          p = Payment.new
          expiry = p.get_expiry(1, nil)
          expiry.should == "01#{Time.now.year.to_s.split("")[2..3].join("")}"
        end
        
        it "should return a valid expiry format if nil is passed for month" do
          p = Payment.new()
          expiry = p.get_expiry(nil, 2012)
          expiry.should == "0112"
        end
        
        it "should default to current year for passing empty string year" do
          p = Payment.new
          expiry = p.get_expiry(1, "")
          expiry.should == "01#{Time.now.year.to_s.split("")[2..3].join("")}"
        end
        
        it "should return a valid expiry format if an empty string is passed for month" do
          p = Payment.new()
          expiry = p.get_expiry("", 2012)
          expiry.should == "0112"
        end
        
        it "should add zero before month number if single digit is passed for month" do
          p = Payment.new()
          expiry = p.get_expiry(1, 2012)
          expiry.should == "0112"
        end
        
        it "should be properly formatted for two digit months" do
          p = Payment.new()
          expiry = p.get_expiry(12, 2012)
          expiry.should == "1212"
        end

        it "should be properly formatted for four digit years" do
          p = Payment.new()
          expiry = p.get_expiry(12, 2012)
          expiry.should == "1212"
        end
        
        it "should be properly formatted for three digit years" do
          p = Payment.new()
          expiry = p.get_expiry(12, 012)
          expiry.should == "12#{Time.now.year.to_s.split("")[2..3].join("")}"
        end
        
        it "should be properly formatted for two digit years" do
          p = Payment.new()
          expiry = p.get_expiry(12, 12)
          expiry.should == "12#{Time.now.year.to_s.split("")[2..3].join("")}"
        end
        
        it "should be properly formatted for one digit years" do
          p = Payment.new()
          expiry = p.get_expiry(12, 2)
          expiry.should == "12#{Time.now.year.to_s.split("")[2..3].join("")}"
        end 
      end
    end

    context "bank account" do
      before(:all) do 
        @info_params["routing_number"] = "051404260"
        @info_params["account_number"] = "0000159924689"
        @info_params["bank_name"] = "BBT"
        @info_params["account_type"] = "Checking"
      end

      it "should validate attributes" do
        p = Payment.new()
        p.valid? == true
      end

      it "should create an ARB subscription" do
        p = Payment.create(@info_params)
        p.arb_id.nil? == false
      end

      it "should be active after create" do
        p = Payment.create(@info_params)
        p.is_active? == true
      end
    end
    
    context "payment type agnostic" do
      it "should show 0 days if new" do
        p = Payment.new()
        p.days_left_until_rebill == 0
      end

      it "should show 364 days if created yesterday" do
        p = Payment.new()
        p.start_date = Time.now - 1.day
        p.days_left_until_rebill == 364
      end

      it "should show 355 days if created 10 days ago" do
        p = Payment.new()
        p.start_date = Time.now - 10.day
        p.days_left_until_rebill == 355
      end
    end
  end
  
  context "cancel payment" do
    before(:all) do
      Payment.all.each{|p| p.destroy}
      @org = FactoryGirl.build_stubbed(:organization)
      @info_params = {
        regular_amount_in_cents: 100,
        starting_amount_in_cents: 100,
        billing_first_name: "Test",
        billing_last_name: "User",
        billing_address: "123 Awesome St",
        billing_city: "Browntown",
        billing_state: "MO",
        billing_zipcode: "12345",
        organization_id: @org.id
      }
      @info_params["payment_type"] = "cc"
      @info_params["number"] = "4007000000027"
      @info_params["ccv"] = "123"
      @info_params["expiry_month"] = 10
      @info_params["expiry_year"] = 2020
    end
    
    before(:each) do
      @payment = Payment.create(@info_params)
    end

    it "should cancel if created" do
      response = @payment.cancel
      @payment.is_active? == false
    end
    
    it "should not cancel if not persisted" do
      p = Payment.new(@info_params)
      response = p.cancel
      response.should == false
    end
  
    it "should update the end_date to today when cancelled" do
      @payment.cancel
      @payment.end_date == Date.today        
    end
    
    it "should mark as inactive when cancelled" do
      @payment.cancel
      @payment.is_active? == false
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

    subject(:payment) { Payment.build_provisional(organization: org) }

    it { should_not be_persisted }

    it 'has a future expiration date' do
      expect(payment.expiry_year.to_i).to be > 3400
    end

    it 'copies contact data from the organization' do
      expect(payment.billing_address).to eq(org.address)
      expect(payment.billing_phone_number).to eq(org.phone_number)
    end
  end

  describe 'billing_date_after(time)' do
    let(:payment) {
      FactoryGirl.build(:payment, start_date: start_date)
    }

    let(:start_date) { Time.zone.parse('May 13, 2013') }

    subject(:next_billing_date) {
      payment.billing_date_after(time)
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
  end

  describe 'build_subscription_object' do
    let(:org) { FactoryGirl.build_stubbed(:organization) }
    let(:payment) {
      FactoryGirl.build(:payment,
        organization: org,
        start_date: Time.now,
        starting_amount_in_cents: 5000,
        billing_first_name: 'Fred',
        billing_phone_number: '555-232-2832'
      )
    }
    let(:subscription_double) { double }
    subject(:subscription) {
      payment.send(:build_subscription_object)
    }

    before do
      AuthorizeNet::ARB::Subscription.
        stub(:new).and_return(subscription_double)
    end

    it 'builds an ARB subscription' do
      AuthorizeNet::ARB::Subscription.
        should_receive(:new) do |hash|
          expect(hash[:billing_address][:first_name]).
            to eq(payment.billing_first_name)
          expect(hash[:customer][:phone_number]).
            to eq(payment.billing_phone_number)
          expect(hash[:start_date]).
            to eq(payment.start_date)
          expect(hash[:trial_occurrences]).
            to eq(1)
          expect(hash[:trial_amount]).
            to eq(50.0)
          expect(hash).not_to have_key(:subscription_id)
      end

      subscription
    end

    it 'returns the ARB subscription' do
      expect(subscription).to eq(subscription_double)
    end
  end

  describe 'build_refresh_subscription_object' do
    let(:org) {
      FactoryGirl.build_stubbed(:organization,
        name: 'Refresh, Inc.'
      )
    }
    let(:payment) {
      FactoryGirl.build(:payment,
        organization: org,
        start_date: Time.zone.parse('May 13, 2013'),
        billing_first_name: 'Fred',
        billing_email: 'refresh@test.host'
      )
    }
    let(:subscription_double) { double }
    subject(:subscription) {
      payment.send(:build_refresh_subscription_object)
    }

    before do
      Timecop.freeze(Time.parse('March 31, 2014'))

      AuthorizeNet::ARB::Subscription.
        stub(:new).and_return(subscription_double)
    end

    it 'builds an ARB subscription' do
      AuthorizeNet::ARB::Subscription.
        should_receive(:new) do |hash|
        expect(hash[:billing_address][:company]).
          to eq('Refresh, Inc.')
        expect(hash[:customer][:email]).
          to eq(payment.billing_email)
        expect(hash[:start_date]). # 1 year after original start
          to eq(Time.zone.parse('May 13, 2014'))
        expect(hash).not_to have_key(:subscription_id)
        expect(hash).not_to have_key(:trial_occurrences)
        expect(hash).not_to have_key(:trial_amount)
      end

      subscription
    end

    it 'returns the ARB subscription' do
      expect(subscription).to eq(subscription_double)
    end
  end

  describe 'build_subscription_object_for_update' do
    let(:org) { FactoryGirl.build_stubbed(:organization) }
    let(:payment) {
      FactoryGirl.build(:payment,
        arb_id: 23,
        organization: org,
        billing_zipcode: '94043',
        billing_email: 'update@test.host'
      )
    }
    let(:subscription_double) { double }
    subject(:subscription) {
      payment.send(:build_subscription_object_for_update)
    }

    before do
      AuthorizeNet::ARB::Subscription.
        stub(:new).and_return(subscription_double)
    end

    it 'builds an ARB subscription' do
      AuthorizeNet::ARB::Subscription.
        should_receive(:new) do |hash|
        expect(hash[:billing_address][:zip]).
          to eq(payment.billing_zipcode)
        expect(hash[:customer][:email]).
          to eq(payment.billing_email)
        expect(hash[:subscription_id]).
          to eq(payment.arb_id)
        expect(hash).not_to have_key(:start_date)
      end

      subscription
    end

    it 'returns the ARB subscription' do
      expect(subscription).to eq(subscription_double)
    end
  end
end
  
