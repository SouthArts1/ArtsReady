require 'spec_helper'

describe MemberController do

  describe "GET 'index'" do
    it "should fail when not logged in" do
      get 'index'
      response.should_not be_success
    end
  end
end
