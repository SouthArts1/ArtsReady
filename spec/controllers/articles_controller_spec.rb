require File.dirname(__FILE__) + '/../spec_helper'

describe ArticlesController do
  fixtures :all
  render_views
  
  def valid_attributes
    {
      :title => 'Title',
      :description => 'Description'
    }
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





    describe "POST create" do
      describe "with valid params" do
        it "creates a new Article" do
          expect {
            post :create, :article => valid_attributes
          }.to change(Article, :count).by(1)
        end

        it "assigns a newly created article as @article" do
          post :create, :article => valid_attributes
          assigns(:article).should be_a(Article)
          assigns(:article).should be_persisted
        end

        it "redirects to the created article" do
          post :create, :article => valid_attributes
          response.should redirect_to(Article.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved article as @article" do
          # Trigger the behavior that occurs when invalid params are submitted
          Article.any_instance.stub(:save).and_return(false)
          post :create, :article => {}
          assigns(:article).should be_a_new(Article)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Article.any_instance.stub(:save).and_return(false)
          post :create, :article => {}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested article" do
          article = Article.create! valid_attributes
          # Assuming there are no other articles in the database, this
          # specifies that the Article created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Article.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => article.id, :article => {'these' => 'params'}
        end

        it "assigns the requested article as @article" do
          article = Article.create! valid_attributes
          put :update, :id => article.id, :article => valid_attributes
          assigns(:article).should eq(article)
        end

        it "redirects to the article" do
          article = Article.create! valid_attributes
          put :update, :id => article.id, :article => valid_attributes
          response.should redirect_to(article)
        end
      end

      describe "with invalid params" do
        it "assigns the article as @article" do
          article = Article.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Article.any_instance.stub(:save).and_return(false)
          put :update, :id => article.id.to_s, :article => {}
          assigns(:article).should eq(article)
        end

        it "re-renders the 'edit' template" do
          article = Article.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Article.any_instance.stub(:save).and_return(false)
          put :update, :id => article.id.to_s, :article => {}
          response.should render_template("edit")
        end
      end
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