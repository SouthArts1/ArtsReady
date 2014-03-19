require 'spec_helper'

describe Admin::UsersController do
  context "logged in a sysadmin" do
    let(:sysadmin) { FactoryGirl.create(:sysadmin)}

    before(:each) do
      controller.stub(:authenticate_admin!).and_return(sysadmin)
    end

    describe "GET 'index'" do
      it "should succeed" do
        get 'index'

        response.should be_success
        assigns(:users).should_not be_nil
      end
    end

    context 'given an organization' do
      let(:organization) { FactoryGirl.create(:organization)}

      describe "GET 'index'" do
        it "should succeed" do
          get 'index', :organization_id => organization.id

          response.should be_success
          assigns(:organization).should eq(organization)
          assigns(:users).should_not be_nil
        end
      end
    end
  end
  
end

