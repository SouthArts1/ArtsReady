class CommentsController < ApplicationController

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(params[:comment])
    @comment.user = current_user
    if @comment.save
      redirect_to article_path(@article), :notice => "Comment added"
    else
      redirect_to article_path(@article), :notice => "Problem with your comment"
    end
  end

end
