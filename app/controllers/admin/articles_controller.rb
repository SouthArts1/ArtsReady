class Admin::ArticlesController < Admin::AdminController

  def update
    @article = Article.find(params[:id])
       
    if ["featured"].include?(params[:toggle])
      @article.toggle(params[:toggle])
      @article.save
      redirect_to article_path(@article), :notice => "Article updated"
    else
      redirect_to article_path(@article), :notice => "Problem updating article"
    end
  end
  
end