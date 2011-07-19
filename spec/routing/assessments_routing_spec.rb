require "spec_helper"

describe AssessmentsController do
  describe "routing" do

    it "does not route to #index" do
      get("/assessments").should_not be_routable
    end

    it "routes to #new" do
      get("/assessment/new").should route_to("assessments#new")
    end

    it "routes to #show" do
      get("/assessment").should route_to("assessments#show")
    end

    it "does not route to #edit" do
      get("/assessments/1/edit").should_not be_routable
    end

    it "routes to #create" do
      post("/assessment").should route_to("assessments#create")
    end

    it "does not route to #update" do
      put("/assessment/1").should_not be_routable
    end

    it "does not route to #destroy" do
      delete("/assessment/1").should_not be_routable
    end

  end
end
