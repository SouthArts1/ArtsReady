require "spec_helper"

describe SessionsController do
  describe "routing" do

    it "routes GET /sign_in to #new" do
      get("/sign_in").should route_to("sessions#new")
    end

    it "routes POST /sign_in to #create" do
      post("/sign_in").should route_to("sessions#create")
    end

    it "routes GET /sign_out to #destroy" do
      get("/sign_out").should route_to("sessions#destroy")
    end

    it "does not route to #index" do
      get("/sessions").should_not be_routable
    end

    it "does not route to #new" do
      get("/sessions/new").should_not be_routable
    end

    it "does not route to #show" do
      get("/sessions/1").should_not be_routable
    end

    it "does not route to #edit" do
      get("/sessions/1/edit").should_not be_routable
    end

    it "does not route to #create" do
      post("/sessions").should_not be_routable
    end

    it "does not route to #update" do
      put("/sessions/1").should_not be_routable
    end

    it "does not route to #destroy" do
      delete("/sessions/1").should_not be_routable
    end

  end
end