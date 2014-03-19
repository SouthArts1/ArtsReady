require "spec_helper"

describe Admin::UsersController do
  describe "routing" do

    it 'routes to #index' do
      get('/admin/users').
        should route_to(
          :controller => 'admin/users',
          :action => 'index')
    end

    it 'routes to #index for an organization' do
      org = FactoryGirl.create(:organization)

      get("/admin/organizations/#{org.id}/users").
        should route_to(
          :controller => 'admin/users',
          :action => 'index',
          :organization_id => org.id.to_s)
    end
  end
end

