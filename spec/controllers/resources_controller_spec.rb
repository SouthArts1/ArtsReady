require 'spec_helper'

describe ResourcesController do

  def valid_attributes
    {:organization_id => 1}
  end

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

    describe "GET index" do
      it "assigns all resources as @resources" do
        resource = Resource.create! valid_attributes
        get :index
        assigns(:resources).should eq([resource])
      end
    end

    describe "GET show" do
      it "assigns the requested resource as @resource" do
        resource = Resource.create! valid_attributes
        get :show, :id => resource.id.to_s
        assigns(:resource).should eq(resource)
      end
    end

    describe "GET new" do
      it "assigns a new resource as @resource" do
        get :new
        assigns(:resource).should be_a_new(Resource)
      end
    end

    describe "GET edit" do
      it "assigns the requested resource as @resource" do
        resource = Resource.create! valid_attributes
        get :edit, :id => resource.id.to_s
        assigns(:resource).should eq(resource)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Resource" do
          expect {
            post :create, :resource => valid_attributes
          }.to change(Resource, :count).by(1)
        end

        it "assigns a newly created resource as @resource" do
          post :create, :resource => valid_attributes
          assigns(:resource).should be_a(Resource)
          assigns(:resource).should be_persisted
        end

        it "redirects to the created resource" do
          post :create, :resource => valid_attributes
          response.should redirect_to(Resource.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved resource as @resource" do
          # Trigger the behavior that occurs when invalid params are submitted
          Resource.any_instance.stub(:save).and_return(false)
          post :create, :resource => {}
          assigns(:resource).should be_a_new(Resource)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Resource.any_instance.stub(:save).and_return(false)
          post :create, :resource => {}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested resource" do
          resource = Resource.create! valid_attributes
          # Assuming there are no other resources in the database, this
          # specifies that the Resource created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Resource.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => resource.id, :resource => {'these' => 'params'}
        end

        it "assigns the requested resource as @resource" do
          resource = Resource.create! valid_attributes
          put :update, :id => resource.id, :resource => valid_attributes
          assigns(:resource).should eq(resource)
        end

        it "redirects to the resource" do
          resource = Resource.create! valid_attributes
          put :update, :id => resource.id, :resource => valid_attributes
          response.should redirect_to(resource)
        end
      end

      describe "with invalid params" do
        it "assigns the resource as @resource" do
          resource = Resource.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Resource.any_instance.stub(:save).and_return(false)
          put :update, :id => resource.id.to_s, :resource => {}
          assigns(:resource).should eq(resource)
        end

        it "re-renders the 'edit' template" do
          resource = Resource.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Resource.any_instance.stub(:save).and_return(false)
          put :update, :id => resource.id.to_s, :resource => {}
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested resource" do
        resource = Resource.create! valid_attributes
        expect {
          delete :destroy, :id => resource.id.to_s
        }.to change(Resource, :count).by(-1)
      end

      it "redirects to the resources list" do
        resource = Resource.create! valid_attributes
        delete :destroy, :id => resource.id.to_s
        response.should redirect_to(resources_url)
      end
    end
  end
end