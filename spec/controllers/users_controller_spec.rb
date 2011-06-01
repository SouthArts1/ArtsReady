require 'spec_helper'

describe UsersController do

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    it "should load a user" do
      get 'new'
      assigns(:user).should be_present
    end
  end

  describe "GET 'create'" do
  end

end
