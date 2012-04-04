require 'spec_helper'

describe Admin::HomeController do
  
  describe "GET 'dashboard'" do
    it "should fail" do
      get 'dashboard'
      response.should_not be_success
    end
  end

  context "logged in as user" do
    let(:organization) { Factory.create(:organization)}

    before(:each) do
      controller.stubs :authenticate!
      controller.stub(:current_org).and_return(organization)
    end

    describe "GET 'dashboard'" do
      it "should fail" do
        get 'dashboard'
        response.should_not be_success
      end
    end

  end

  context "logged in a sysadmin" do
    let(:sysadmin) { Factory.create(:sysadmin)}
    let(:organization) { Factory.create(:organization)}

    before(:each) do
      controller.stub(:authenticate_admin!).and_return(sysadmin)
      controller.stub(:current_org).and_return(organization)
    end

    describe "GET 'dashboard'" do
      it "should succeed" do
        get 'dashboard'
        assigns(:crises).should_not be_nil
        assigns(:expiring).should_not be_nil
        response.should be_success
      end
    end
  end
  
end
