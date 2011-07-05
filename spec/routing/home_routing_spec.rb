require "spec_helper"

describe HomeController do
  describe "routing" do

    it "routes / to #index" do
      get("/").should route_to("home#index")
    end

    it "routes to #index" do
      get("/home/index").should route_to("home#index")
    end

    it "routes to #library" do
      get("/library").should route_to("home#library")
    end
    
    it "routes to #public_article(/:id)" do
      get("/home/public_article/1").should route_to("home#public_article", :id => "1")
    end
    
    it "routes to #welcome" do
      get("/welcome").should route_to("home#welcome")
    end
    
  end
end
