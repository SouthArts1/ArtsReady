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
      Organization.all.each{|o| o.destroy}
      Payment.all.each{|p| p.destroy}
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
        organization_id: @org.id
      }
      @info_params["payment_type"] = "cc"
      @info_params["number"] = "4007000000027"
      @info_params["ccv"] = "123"
      @info_params["expiry_month"] = 10
      @info_params["expiry_year"] = 2020
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
end
  
