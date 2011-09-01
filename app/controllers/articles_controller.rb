class ArticlesController < ApplicationController

  def index
    if params[:term]
      @articles = current_org.articles.only_private.matching(params[:term]) + Article.for_public.matching(params[:term])
    else
      @articles = current_org.articles.only_private + Article.for_public
    end
  end

  def critical_list
    @critical_list = current_org.articles.on_critical_list
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
    end
  end

  def create
    #TODO fix this hack
    if params[:buddy_list].present?
      buddy_list = params[:buddy_list].collect {|i| i.to_i}.join(',')
      params[:article].merge!(:buddy_list => buddy_list)
    end
    
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
    #TODO fix this hack
    if params[:buddy_list].present?
      buddy_list = params[:buddy_list].collect {|i| i.to_i}.join(',')
      params[:article].merge!(:buddy_list => buddy_list)
    end
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