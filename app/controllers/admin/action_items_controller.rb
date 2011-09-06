class Admin::ActionItemsController < Admin::AdminController
  
  def create
    @action_item = ActionItem.create(params[:action_item])
    if @action_item.save
      redirect_to edit_admin_question_path(@action_item.question), :notice => "Action item added"
    else
      redirect_to edit_admin_question_path(@action_item.question), :notice => "Problem with your action item"
    end
  end

  def update
    @action_item = ActionItem.find(params[:id])

    if @action_item.update_attributes(params[:action_item])
      redirect_to edit_admin_question_path(@action_item.question), :notice => "Action item updated"
    else
      redirect_to edit_admin_question_path(@action_item.question), :notice => "Problem with your action item"
    end
  end
  
  def destroy
    @action_item = ActionItem.find(params[:id])
    @action_item.update_attribute(:deleted,true)
    redirect_to edit_admin_question_path(@action_item.question)
  end
  
end