require 'spec_helper'

describe "Resources" do
  describe "GET /resources" do
    it "should redirect for auth" do
      get resources_path
      response.status.should be(302)
    end
  end
end
