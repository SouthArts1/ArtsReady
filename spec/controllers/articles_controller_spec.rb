require 'spec_helper'

describe ArticlesController do
  fixtures :all
  render_views
  
  def valid_attributes
    Factory.attributes_for(:article)
  end

  context "logged in" do
    let(:user) { Factory.create(:user) }
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
      article = Factory.create(:article,
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
          post :create, :article => {}
          assigns(:article).should be_a_new(Article)
        end

        it "re-renders the 'new' template" do
          post :create, :article => {}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested article" do
          article = Factory.create(:article, :organization => organization)
          # Assuming there are no other articles in the database, this
          # specifies that the Article created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          expect_any_instance_of(Article).
            to receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => article.id, :article => {'these' => 'params'}
        end

        it "assigns the requested article as @article" do
          article = Factory.create(:article, :organization => organization)
          put :update, :id => article.id, :article => valid_attributes
          assigns(:article).should eq(article)
        end

        it "redirects to the article" do
          article = Factory.create(:article, :organization => organization)
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
          article = Factory.create(:article, :organization => organization)
          put :update, :id => article.id.to_s, :article => {}
          assigns(:article).should eq(article)
        end

        it "re-renders the 'edit' template" do
          article = Factory.create(:article, :organization => organization)
          put :update, :id => article.id.to_s, :article => {}
          response.should render_template("edit")
        end
      end
    end

    it "create action should redirect to todo when article has a todo" do
      todo = Factory.create(:todo)
      post(:create, :article =>
        Factory.attributes_for(:article, :todo_id => todo.id))
      response.should redirect_to todo
    end
    
    it "edit action should render edit template" do
      article = Factory.create(:article,
        :organization => organization, :user => user)
      get :edit, :id => article.id
      response.should render_template(:edit)
    end

    it "destroy action should destroy model and redirect to index action" do
      article = Factory.create(:article,
        :organization => organization, :user => user)
      delete :destroy, :id => article.id
      response.should redirect_to(articles_url)
      Article.exists?(article.id).should be_false
    end
  end
end
