require 'spec_helper'

describe PagesController do

  let(:page) { Factory.create(:page) }
  
  describe "GET 'show'" do
    it "should be successful" do
      get 'show', :slug => page.slug
      response.should be_success
    end
  end

end
