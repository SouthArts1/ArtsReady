require "spec_helper"

describe BuddiesController do
  describe "routing" do

    it "routes to #get_help" do
      get("/get_help").should route_to("buddies#get_help")
    end

    it "routes to #lend_a_hand" do
      get("/lend_a_hand").should route_to("buddies#lend_a_hand")
    end

    it "routes to #index" do
      get("/buddies").should route_to("buddies#index")
    end

    it "routes to #profile" do
      get("/buddies/profile").should route_to("buddies#profile")
    end

  end
end
