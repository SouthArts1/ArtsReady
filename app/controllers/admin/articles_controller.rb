class Admin::ArticlesController < Admin::AdminController

  def update
    @article = Article.find(params[:id])
       
    if ["featured", "disabled"].include?(params[:toggle])
      @article.toggle(params[:toggle])
      @article.save
      redirect_to article_path(@article), :notice => "Article updated"
    else
      redirect_to article_path(@article), :notice => "Problem updating article"
    end
  end
  
  def destroy
    @article = Article.find(params[:id])
    @article.update_attribute(:disabled, true)
    redirect_to articles_url, :notice => "Successfully disabled article."
    
  end
  
end