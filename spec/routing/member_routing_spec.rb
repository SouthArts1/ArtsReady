require "spec_helper"

describe MemberController do
  describe "routing" do

    it "routes dashboard to #index" do
      get("/member/index").should route_to("member#index")
    end

  end
end
