class TodosController < ApplicationController

  def index
    @todos = current_org.todos.in_action_order

    respond_to do |format|
      format.csv do
        render :layout => false
      end
      format.html do
        critical_function = (params[:tab] ||= 'people')
        @todos = @todos.for_critical_function(critical_function).to_a
        @todo = current_org.todos.new
      end
    end
  end

  def show
    @todo = current_org.todos.find(params[:id])
  end

  def edit
    @todo = current_org.todos.find(params[:id])
  end

  def create
    @todo = current_org.todos.new(todo_params.merge({:last_user => current_user}))

    if @todo.save
      redirect_to :back, :notice => 'To-Do was successfully created.'
    else
      redirect_to :back, :notice => 'There was a problem with your To-Do'
    end

  end

  def update
    @todo = current_org.todos.find(params[:id])
    if @todo.update_attributes(todo_params.merge({:last_user => current_user}))

      respond_to do |format|
        format.html { redirect_to todos_path(:tab => @todo.critical_function), :notice => 'Todo was successfully updated.' }  
        format.js
      end
      
    else
      render 'edit'
    end

  end

  private

  def todo_params
    params.require(:todo).permit(
      :description, :critical_function, :action,
      :user_id, :due_on, :priority, :complete
    )
  end

end
