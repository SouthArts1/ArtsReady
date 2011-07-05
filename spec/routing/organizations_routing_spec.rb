require "spec_helper"

describe OrganizationsController do
  describe "routing" do

    it "routes to #show" do
      get("/organizations/1").should route_to("organizations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/organizations/1/edit").should route_to("organizations#edit", :id => "1")
    end

    it "routes to #update" do
      put("/organizations/1").should route_to("organizations#update", :id => "1")
    end

    it "routes to #index" do
      get("/organizations").should_not be_routable
    end

    it "routes to #new" do
      get("/organizations/new").should_not be_routable
    end
    it "routes to #create" do
      post("/organizations").should_not be_routable
    end

    it "routes to #destroy" do
      delete("/organizations/1").should_not be_routable
    end

  end
end
