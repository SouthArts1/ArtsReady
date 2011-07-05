require 'spec_helper'

describe BuddiesController do

  context "when not logged in" do
    it "requires authentication" do
      controller.expects :authenticate!
      get 'index'
    end
  end

  context "logged in" do
    let(:organization) { Factory(:organization)}
    before(:each) do
      controller.stubs :authenticate!
      controller.stub(:current_org).and_return(organization)
    end

    describe "GET 'help'" do
      it "should be successful" do
        get 'get_help'
        response.should be_success
      end
    end

    describe "GET 'offer'" do
      it "should be successful" do
        get 'lend_a_hand'
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
