require 'spec_helper'

describe ArticlesController do
  fixtures :all
  render_views
  
  def valid_attributes
    FactoryGirl.attributes_for(:article)
  end

  context "logged in" do
    let(:user) { FactoryGirl.create(:user) }
    let(:organization) { user.organization }

    before(:each) do
      controller.stubs :authenticate!
      controller.stub(:current_org).and_return(organization)
      controller.stub(:current_user).and_return(user)
    end

    context "#index" do
      it "renders :index template" do
        get 'index'
        should render_template(:index)
      end

      it "assigns @articles" do
        active_org_article = FactoryGirl.create(:public_article,
                                               :user => user,
                                               :organization => organization)
        Article.stub_chain(:of_active_orgs, :visible_to_organization) {
          [active_org_article]
        }

        get 'index'
        assigns(:articles).should eq([active_org_article])
      end
    end

    it "show action should render show template" do
      article = FactoryGirl.create(:article,
        :organization => organization, :user => user)
      get :show, :id => article.id
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
          article = FactoryGirl.create(:article, :organization => organization)
          # Assuming there are no other articles in the database, this
          # specifies that the Article created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Article.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => article.id, :article => {'these' => 'params'}
        end

        it "assigns the requested article as @article" do
          article = FactoryGirl.create(:article, :organization => organization)
          put :update, :id => article.id, :article => valid_attributes
          assigns(:article).should eq(article)
        end

        it "redirects to the article" do
          article = FactoryGirl.create(:article, :organization => organization)
          put :update, :id => article.id, :article => valid_attributes
          response.should redirect_to(article)
        end
      end

      describe "with invalid params" do
        it "assigns the article as @article" do
          article = FactoryGirl.create(:article, :organization => organization)
          # Trigger the behavior that occurs when invalid params are submitted
          Article.any_instance.stub(:save).and_return(false)
          put :update, :id => article.id.to_s, :article => {}
          assigns(:article).should eq(article)
        end

        it "re-renders the 'edit' template" do
          article = FactoryGirl.create(:article, :organization => organization)
          # Trigger the behavior that occurs when invalid params are submitted
          Article.any_instance.stub(:save).and_return(false)
          put :update, :id => article.id.to_s, :article => {}
          response.should render_template("edit")
        end
      end
    end



    it "create action should render new template when model is invalid" do
      Article.any_instance.stub(:valid?).and_return(false)
      post :create, :article => {}
      response.should render_template(:new)
    end

    it "create action should redirect when model is valid" do
      post :create, :article => FactoryGirl.attributes_for(:article)
      response.should redirect_to(article_url(assigns[:article]))
    end

    it "create action should redirect to todo when article has a todo" do
      todo = FactoryGirl.create(:todo)
      post(:create, :article =>
        FactoryGirl.attributes_for(:article, :todo_id => todo.id))
      response.should redirect_to todo
    end
    
    it "edit action should render edit template" do
      article = FactoryGirl.create(:article,
        :organization => organization, :user => user)
      get :edit, :id => article.id
      response.should render_template(:edit)
    end

    it "update action should render edit template when model is invalid" do
      article = FactoryGirl.create(:article,
        :organization => organization, :user => user)
      put :update, :id => article.id, :article => {:title => ''}
      response.should render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      Article.any_instance.stub(:valid?).and_return(true)
      article = FactoryGirl.create(:article,
        :organization => organization, :user => user)
      put :update, :id => article.id
      response.should redirect_to(article_url(assigns[:article]))
    end

    it "destroy action should destroy model and redirect to index action" do
      article = FactoryGirl.create(:article,
        :organization => organization, :user => user)
      delete :destroy, :id => article.id
      response.should redirect_to(articles_url)
      Article.exists?(article.id).should be_false
    end

  end
end
