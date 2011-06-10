class HomeController < ApplicationController

  def index
    @featured_articles = Article.featured
    @public_articles = Article.for_public.limit(3)
  end
  
  def library
    @public_articles = Article.for_public
  end
  
  def public_article
    @article = Article.find(params[:id])
    if !@article.is_public?
      render :text => 'Not a public record!'
    else
    end
  end
  
  def tbd
    render :text => 'TBD'
  end
  

end
