require "spec_helper"

describe HomeController do
  describe "routing" do

    it "routes / to #index" do
      get("/").should route_to("home#index")
    end

    it "routes to #readiness_library" do
      get("/readiness_library").should route_to("home#readiness_library")
    end
    
    it "routes to #public_article(/:id)" do
      get("/home/public_article/1").should route_to("home#public_article", :id => "1")
    end
    
  end
end
