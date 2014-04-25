require 'spec_helper'

describe Admin::PagesController do

  context "a visitor" do
    let(:page) { Factory.create(:page)}

    describe "GET 'index'" do
      it "should fail" do
        get 'index'
        response.should_not be_success
      end
    end

    describe "GET 'edit'" do
      it "should fail" do
        get 'edit', :id => page.id
        response.should_not be_success
      end
    end

    describe "PUT 'edit'" do
      it "should fail" do
        put :update, :id => page.id, :page => {'these' => 'params'}
        response.should_not be_success
      end
    end

  end
  
  context "logged in as user" do
    let(:organization) { Factory.create(:organization) }
    let(:page) { Factory.create(:page)}

    before(:each) do
      controller.stubs :authenticate!
      controller.stub(:current_org).and_return(organization)
    end

    describe "GET 'index'" do
      it "should fail" do
        get 'index'
        response.should_not be_success
      end
    end

    describe "GET 'edit'" do
      it "should fail" do
        get 'edit', :id => page.id
        response.should_not be_success
      end
    end

    describe "PUT 'edit'" do
      it "should fail" do
        put :update, :id => page.id, :page => {'these' => 'params'}
        response.should_not be_success
      end
    end

  end
  

  context "logged in a sysadmin" do
    let(:sysadmin) { Factory.create(:sysadmin)}
    let(:page) { Factory.create(:page)}

    before(:each) do
      controller.stub(:authenticate_admin!).and_return(sysadmin)
      Page.stub(:find).and_return(page)
    end

    describe "GET 'index'" do
      it "should succeed" do
        get 'index'
        assigns(:pages).should_not be_nil        
        response.should be_success
      end
    end

    describe "GET 'edit'" do
      it "should succeed" do
        get 'edit', :id => page.id
        assigns(:page).should_not be_nil        
        response.should be_success
      end
    end

    describe "PUT 'update'" do
      it "should succeed" do
        page.should_receive(:update_attributes).with('body' => 'params')
        put :update, :id => page.id, :page => {'body' => 'params'}
        response.should redirect_to admin_pages_path
      end
    end

  end

end
