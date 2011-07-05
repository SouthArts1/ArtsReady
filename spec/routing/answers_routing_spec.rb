require "spec_helper"

describe AnswersController do
  describe "routing" do

    it "does not route to #index" do
      get("/answers").should_not be_routable
    end

    it "does not route to #new" do
      get("/answers/new").should_not be_routable
    end

    it "does not route to #show" do
      get("/answers/1").should_not be_routable
    end

    it "does not route to #edit" do
      get("/answers/1/edit").should_not be_routable
    end

    it "does not route to #create" do
      post("/answers").should_not be_routable
    end

    it "routes to #update" do
      put("/answers/1").should route_to("answers#update", :id => "1")
    end

    it "does not route to #destroy" do
      delete("/answers/1").should_not be_routable
    end

  end
end
