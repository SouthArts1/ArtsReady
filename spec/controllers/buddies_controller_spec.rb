require 'spec_helper'

describe BuddiesController do

  let(:organization) { Factory.create(:organization)}
  context "when not logged in" do
    it "requires authentication" do
      controller.expects :authenticate!
      controller.stubs(:current_org).returns(organization)
      get 'lend_a_hand'
    end

    it "redirects to the sign in page" do
      get 'lend_a_hand'
      should redirect_to :sign_in
    end
  end

  context "logged in" do
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

  end

end
