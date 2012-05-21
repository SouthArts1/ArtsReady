require "spec_helper"

describe PaymentVariablesController do
  describe "routing" do

    it "routes to #index" do
      get("/payment_variables").should route_to("payment_variables#index")
    end

    it "routes to #new" do
      get("/payment_variables/new").should route_to("payment_variables#new")
    end

    it "routes to #show" do
      get("/payment_variables/1").should route_to("payment_variables#show", :id => "1")
    end

    it "routes to #edit" do
      get("/payment_variables/1/edit").should route_to("payment_variables#edit", :id => "1")
    end

    it "routes to #create" do
      post("/payment_variables").should route_to("payment_variables#create")
    end

    it "routes to #update" do
      put("/payment_variables/1").should route_to("payment_variables#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/payment_variables/1").should route_to("payment_variables#destroy", :id => "1")
    end

  end
end
