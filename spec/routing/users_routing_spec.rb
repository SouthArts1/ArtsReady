require "spec_helper"

describe UsersController do
  describe "routing" do

    it "routes to #new" do
      get("/users/new").should route_to("users#new")
    end

    it "routes to #create" do
      post("/users").should route_to("users#create")
    end

    it "does not route to #index" do
      get("/users").should_not be_routable
    end

    it "does not route to #show" do
      get("/users/1").should_not be_routable
    end

    it "does not route to #edit" do
      get("/users/1/edit").should_not be_routable
    end

    it "does not route to #update" do
      put("/users/1").should_not be_routable
    end

    it "does not route to #destroy" do
      delete("/users/1").should_not be_routable
    end

  end
end
