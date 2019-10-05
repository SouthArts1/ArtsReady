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
      controller.stub(:current_org).and_return(nil)
      get 'edit', :id => 1
    end
  end

  context "logged in" do
    let(:organization) { Factory.create(:organization)}
    before(:each) do
      controller.stubs :authenticate!
      controller.stub(:current_org).and_return(organization)
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
          organization.should_receive(:update_attributes).with({'name' => 'An Org'})
          put :update, :id => organization.id, :organization => {'name' => 'An Org'}
        end

        it "assigns the requested organization as @organization" do
          put :update, :id => organization.id, :organization => valid_attributes
          assigns(:organization).should eq(organization)
        end

        it "redirects to the dashboard" do
          put :update, :id => organization.id, :organization => valid_attributes
          response.should redirect_to edit_organization_path(organization.id)
        end
      end

      describe "with invalid params" do
        before do
          # Trigger the behavior that occurs when invalid params are submitted
          allow_any_instance_of(Organization).
            to receive(:save).and_return(false)
        end

        it "assigns the organization as @organization" do
          put :update, :id => organization.id.to_s, :organization => {name: 'An Org'}
          assigns(:organization).should eq(organization)
        end

        it "re-renders the 'edit' template" do
          put :update, :id => organization.id.to_s, :organization => {name: 'An Org'}
          response.should render_template("edit")
        end
      end
    end


  end
end
