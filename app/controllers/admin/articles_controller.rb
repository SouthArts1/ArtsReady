class Admin::ArticlesController < Admin::AdminController

  def index
    @articles = Article.disabled
  end
  
  def update
    @article = Article.unscoped.find(params[:id])
       
    if ["featured", "disabled"].include?(params[:toggle])
      @article.toggle(params[:toggle])
      # TODO Email user?
      @article.save
      redirect_to article_path(@article), :notice => "Article updated"
    elsif params[:toggle] = "owner"
      @article.update_attribute(:user_id, current_user.id)
      @article.update_attribute(:organization_id, current_org.id)
      redirect_to article_path(@article), :notice => "Article updated"
    else
      redirect_to article_path(@article), :notice => "Problem updating article"
    end
  end
  
  def destroy
    @article = Article.find(params[:id])
    @article.update_attribute(:disabled, true)
    # TODO Email user?
    redirect_to articles_path, :notice => "Successfully disabled article."  
  end
  
end