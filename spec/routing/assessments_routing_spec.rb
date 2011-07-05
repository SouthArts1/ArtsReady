require "spec_helper"

describe AssessmentsController do
  describe "routing" do

    it "does not route to #index" do
      get("/assessments").should_not be_routable
    end

    it "routes to #new" do
      get("/assessments/new").should route_to("assessments#new")
    end

    it "routes to #show" do
      get("/assessments/1").should route_to("assessments#show", :id => "1")
    end

    it "does not route to #edit" do
      get("/assessments/1/edit").should_not be_routable
    end

    it "routes to #create" do
      post("/assessments").should route_to("assessments#create")
    end

    it "does not route to #update" do
      put("/assessments/1").should_not be_routable
    end

    it "does not route to #destroy" do
      delete("/assessments/1").should_not be_routable
    end

  end
end
