class HomeController < ApplicationController

  skip_before_filter :authenticate!

  def index
    redirect_to dashboard_path if session[:user_id]

    @featured_articles = Article.featured
    @public_articles = Article.only_public.limit(3)
  end

  def readiness_library
    @critical_function_counts = Article.group(:critical_function).count
    @public_articles = Article.for_public
  end

  def public_articles
    if params[:term]
      @public_articles = Article.for_public.matching(params[:term])
    elsif params[:critical_function]
      @public_articles = Article.for_public.with_critical_function(params[:critical_function])
    else
      @public_articles = Article.for_public
    end    
  end

  def public_article
    @article = Article.find(params[:id])
    if !@article.is_public?
      redirect_to :library, :notice => 'That is not a public document.'
    end
  end

  def welcome
    @page = Page.find_by_slug('billing') #rescue OpenStruct(:title => 'Billing', :body => 'Body', :slug => 'Billing')
    render 'pages/show'
  end

  def news
    @page = Page.find_by_slug('news') #rescue OpenStruct(:title => 'Billing', :body => 'Body', :slug => 'Billing')
    render 'pages/show'
  end

end