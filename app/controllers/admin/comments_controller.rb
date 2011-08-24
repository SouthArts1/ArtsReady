class Admin::CommentsController < Admin::AdminController

  def destroy
    @comment = Comment.find(params[:id])
    @comment.update_attribute(:disabled, true)
    redirect_to :back, :notice => "Successfully removed comment."  
  end

end