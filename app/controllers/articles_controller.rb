class ArticlesController < ApplicationController

  def index
    @featured_articles = Article.featured
    @articles = current_org.articles.recent
  end

  def critical_list
    @critical_list = current_org.articles.on_critical_list
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
    if params[:id]
      @article.todo_id = params[:id]
    end
  end

  def create
    @article = current_org.articles.new(params[:article].merge({:user => current_user}))

    if @article.save
      redirect_to @article, :notice => "Successfully created article."
    else
      render 'new'
    end
  end

  def edit
    @article = current_org.articles.find(params[:id])
  end

  def update
    @article = current_org.articles.find(params[:id])
    if @article.update_attributes(params[:article])
      redirect_to @article, :notice  => "Successfully updated article."
    else
      render 'edit'
    end
  end

  def destroy
    @article = current_org.articles.find(params[:id])
    @article.destroy
    redirect_to articles_url, :notice => "Successfully destroyed article."
  end
end