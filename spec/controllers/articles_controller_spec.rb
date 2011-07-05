require File.dirname(__FILE__) + '/../spec_helper'

describe ArticlesController do
  fixtures :all
  render_views

  context "when not logged in" do
    it "requires authentication" do
      controller.expects :authenticate!
      get 'index'
    end
  end

  context "logged in" do
    before(:each) { controller.stubs :authenticate! }

    it "renders :index template" do
      get 'index'
      should render_template(:index)
    end

    it "show action should render show template" do
      get :show, :id => Article.first
      response.should render_template(:show)
    end

    it "new action should render new template" do
      get :new
      response.should render_template(:new)
    end

    it "create action should render new template when model is invalid" do
      Article.any_instance.stubs(:valid?).returns(false)
      post :create
      response.should render_template(:new)
    end

    it "create action should redirect when model is valid" do
      Article.any_instance.stubs(:valid?).returns(true)
      post :create
      response.should redirect_to(article_url(assigns[:article]))
    end
    it "edit action should render edit template" do
      get :edit, :id => Article.first
      response.should render_template(:edit)
    end

    it "update action should render edit template when model is invalid" do
      Article.any_instance.stubs(:valid?).returns(false)
      put :update, :id => Article.first
      response.should render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      Article.any_instance.stubs(:valid?).returns(true)
      put :update, :id => Article.first
      response.should redirect_to(article_url(assigns[:article]))
    end

    it "destroy action should destroy model and redirect to index action" do
      article = Article.first
      delete :destroy, :id => article
      response.should redirect_to(articles_url)
      Article.exists?(article.id).should be_false
    end

  end
end