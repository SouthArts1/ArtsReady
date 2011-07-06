require 'spec_helper'

describe HomeController do

  describe "GET 'index'" do
    it "should be successful" do
      article = Factory(:article)
      controller.stub(:featured_articles).and_return([article])
      get 'index'
      response.should be_success
    end
  end

end
