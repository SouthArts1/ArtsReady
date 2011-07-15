class HomeController < ApplicationController

  skip_before_filter :authenticate!

  def index
    redirect_to dashboard_path if session[:user_id]

    @featured_articles = Article.featured
    @public_articles = Article.for_public.limit(3)
  end

  def library
    @public_articles = Article.for_public
  end

  def public_article
    @article = Article.find(params[:id])
    if !@article.is_public?
      redirect_to :library, :notice => 'That is not a public document.'
    end
  end

  def welcome
  end

  def tbd
  end

end