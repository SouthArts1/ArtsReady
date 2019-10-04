require "spec_helper"

describe Admin::PagesController do
  describe "routing" do

    it "routes to #new" do
      get("/admin/pages/new").should be_routable
    end

    it "routes to #create" do
      post("/admin/pages").should be_routable
    end

    it "routes to #index" do
      get("/admin/pages").should route_to("admin/pages#index")
    end

    it "does not route to #show" do
      get("/admin/pages/1").should_not be_routable
    end

    it "routes to #edit" do
      get("/admin/pages/1/edit").should route_to("admin/pages#edit", :id => "1")
    end

    it "routes to #update" do
      put("/admin/pages/1").should route_to("admin/pages#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/pages/1").should route_to("admin/pages#destroy", :id => "1")
    end

  end
end
