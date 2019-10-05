class ArticlesController < ApplicationController
  skip_before_filter :authenticate!, :only => :show
  before_filter :allow_public_article, :only => :show

  def index
    @articles = Article.visible_to_organization(current_org)
    if params[:term]
      @articles = @articles.matching(params[:term])
    elsif params[:critical_function]
      @articles = @articles.with_critical_function(params[:critical_function]) 
    end
  end

  def critical_list
    @critical_list = current_org.articles.on_critical_list
    if params[:critical_function]
      @critical_list = @critical_list.with_critical_function(params[:critical_function]) 
    end
  end

  def show
    @article = Article.find(params[:id])
    if !@article.can_be_accessed_by?(current_user)
      redirect_to library_path, :notice => 'You are not allowed to access that article'
    end
  end

  def new
    @article = Article.new
    if params[:todo_id]
      @article.todo_id = params[:todo_id]
      @article.critical_function = Todo.find(params[:todo_id]).critical_function
    end
  end

  def create
    #TODO fix this hack
    if params[:buddy_list].present?
      buddy_list = params[:buddy_list].collect {|i| i.to_i}.join(',')
      params[:article].merge!(:buddy_list => buddy_list)
    end
    
    @article = current_org.articles.new(article_params.merge({:user => current_user}))

    if @article.save
      redirect_to @article.todo || @article,
        :notice => "Successfully created article."
    else
      render 'new'
    end
  end

  def edit
    @article = current_org.articles.find(params[:id])
#    authorize! :manage, @article
  end

  def update
    @article = current_org.articles.find(params[:id])
#    authorize! :edit, @article
    #TODO fix this hack
    if params[:buddy_list].present?
      buddy_list = params[:buddy_list].collect {|i| i.to_i}.join(',')
      params[:article].merge!(:buddy_list => buddy_list)
    end
    if @article.update_attributes(article_params)
      redirect_to @article, :notice  => "Successfully updated article."
    else
      render 'edit'
    end
  end

  def destroy
    @article = current_org.articles.find(params[:id])
#    authorize! :destroy, @article
    @article.update_attribute(:disabled, true) if @article.deleteable_by(current_user)
    redirect_to articles_url, :notice => "Successfully destroyed article."
  end

  private

  def article_params
    params.require(:article).permit(
      :title, :description, :tag_list,
      :document, :link, :body,
      :critical_function, :on_critical_list,
      :visibility, :todo_id,
      buddy_list: [])
  end

  def allow_public_article
    @article = Article.find(params[:id])

    if @article.is_public? && !user_signed_in?
      redirect_to public_article_url(@article)
    else
      authenticate!
    end
  end
end
