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
  end
    
  context "creating a new payment object" do
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
        p.object_is_bad? == false
      end
      
      it "should create an ARB subscription" do
        p = Payment.create(@info_params)
        p.arb_id.nil? == false
      end
    end

    context "bank account" do


    end
  end
end
  

