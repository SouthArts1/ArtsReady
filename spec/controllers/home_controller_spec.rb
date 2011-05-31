require 'spec_helper'

describe HomeController do

  describe "GET 'index'" do
    before do
      get 'index'
    end
    it "should be successful" do
      assigns(:featured_articles).should eq(Article.featured)
      response.should be_success
    end
    
    it "should assign one featured article" do
      assigns(:featured_articles).should eq(Article.featured)
      assigns(:featured_articles).size.should eq(1)
    end

    it "should assign three recent public articles" do
      assigns(:public_articles).should eq(Article.recent)
      assigns(:public_articles).size.should eq(3)
    end
  end

end
