require 'spec_helper'

describe OrganizationsController do

  def valid_attributes
    {:address => '1600 Pennsylvannia Ave',
      :name => 'White House',
      :city => 'Washington',
      :state => 'DC',
      :zipcode => '20500'
    }
  end
  
  context "when not logged in" do
    it "requires authentication" do
      controller.expects :authenticate!
      controller.stub!(:current_org).and_return(nil)
      get 'edit', :id => 1
    end
  end

  context "logged in" do
    let(:organization) { Factory(:organization)}
    before(:each) do
      controller.stubs :authenticate!
      controller.stub(:current_org).and_return(organization)
      subject()
    end

    describe "GET 'edit'" do
      it "should be successful" do
        get 'edit',:id => 1
        response.should be_success
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested organization" do
          organization.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => organization.id, :organization => {'these' => 'params'}
        end

        it "assigns the requested organization as @organization" do
          put :update, :id => organization.id, :organization => valid_attributes
          assigns(:organization).should eq(organization)
        end

        it "redirects to the dashboard" do
          put :update, :id => organization.id, :organization => valid_attributes
          response.should redirect_to dashboard_path
        end
      end

      describe "with invalid params" do
        it "assigns the organization as @organization" do
          # Trigger the behavior that occurs when invalid params are submitted
          Organization.any_instance.stub(:save).and_return(false)
          put :update, :id => organization.id.to_s, :organization => {}
          assigns(:organization).should eq(organization)
        end

        it "re-renders the 'edit' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Organization.any_instance.stub(:save).and_return(false)
          put :update, :id => organization.id.to_s, :organization => {}
          response.should render_template("edit")
        end
      end
    end


  end
end