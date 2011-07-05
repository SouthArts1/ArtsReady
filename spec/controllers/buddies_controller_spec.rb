require 'spec_helper'

describe BuddiesController do

  context "when not logged in" do
    it "requires authentication" do
      controller.expects :authenticate!
      get 'index'
    end
  end

  context "logged in" do
    before(:each) { controller.stubs :authenticate! }

    describe "GET 'help'" do
      it "should be successful" do
        get 'help'
        response.should be_success
      end
    end

    describe "GET 'offer'" do
      it "should be successful" do
        get 'offer'
        response.should be_success
      end
    end

    describe "GET 'index'" do
      it "should be successful" do
        get 'index'
        response.should be_success
      end
    end
  end

end
