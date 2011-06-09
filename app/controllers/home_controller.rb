class HomeController < ApplicationController

  def index
    @featured_articles = Article.featured
    @public_articles = Article.recent
  end
  
  def tbd
    render :text => 'TBD'
  end

end
