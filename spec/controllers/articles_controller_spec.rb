require 'spec_helper'

describe ArticlesController do
  fixtures :all
  render_views
  
  def valid_attributes
    FactoryGirl.attributes_for(:article).except(:organization)
  end

  context "logged in" do
    let(:user) { FactoryGirl.create(:user) }
    let(:organization) { user.organization }

    before(:each) do
      controller.stubs :authenticate!
      controller.stub(:current_org).and_return(organization)
      controller.stub(:current_user).and_return(user)
    end

    it "renders :index template" do
      get 'index'
      should render_template(:index)
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
        before do
          # Trigger the behavior that occurs when invalid params are submitted
          allow_any_instance_of(Article).to receive(:save).and_return(false)
        end

        it "assigns a newly created but unsaved article as @article" do
          post :create, :article => {title: 'a title'}
          assigns(:article).should be_a_new(Article)
        end

        it "re-renders the 'new' template" do
          post :create, :article => {title: 'a title'}
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
          expect_any_instance_of(Article).
            to receive(:update_attributes).with({'title' => 'new title'})
          put :update, :id => article.id, :article => {'title' => 'new title'}
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
        before do
          # Trigger the behavior that occurs when invalid params are submitted
          allow_any_instance_of(Article).
            to receive(:save).and_return(false)
        end

        it "assigns the article as @article" do
          article = FactoryGirl.create(:article, :organization => organization)
          put :update, :id => article.id.to_s, :article => {title: 'a title'}
          assigns(:article).should eq(article)
        end

        it "re-renders the 'edit' template" do
          article = FactoryGirl.create(:article, :organization => organization)
          put :update, :id => article.id.to_s, :article => {title: 'a title'}
          response.should render_template("edit")
        end
      end
    end

    it "create action should redirect to todo when article has a todo" do
      todo = FactoryGirl.create(:todo)
      post(:create, :article =>
        FactoryGirl.attributes_for(:article, :todo_id => todo.id).except(:organization))
      response.should redirect_to todo
    end
    
    it "edit action should render edit template" do
      article = FactoryGirl.create(:article,
        :organization => organization, :user => user)
      get :edit, :id => article.id
      response.should render_template(:edit)
    end

    it "destroy action should destroy model and redirect to index action" do
      article = FactoryGirl.create(:article,
        :organization => organization, :user => user)
      delete :destroy, :id => article.id
      response.should redirect_to(articles_url)
      Article.exists?(article.id).should be_falsey
    end
  end
end
