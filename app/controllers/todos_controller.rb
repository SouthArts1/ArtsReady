class TodosController < ApplicationController

  def index
    critical_function = (params[:tab] ||= 'people')
    @todos = current_org.todos.for_critical_function(critical_function)
    @todo = current_org.todos.new
  end

  def show
    @todo = current_org.todos.find(params[:id])
  end

  def edit
    @todo = current_org.todos.find(params[:id])
  end

  def create
    @todo = current_org.todos.new(params[:todo].merge({:last_user => current_user}))

    if @todo.save
      redirect_to :back, :notice => 'Todo was successfully created.'
    else
      redirect_to :back, :notice => 'There was a problem with your todo'
    end

  end

  def update
    @todo = current_org.todos.find(params[:id])
    if @todo.update_attributes(params[:todo].merge({:last_user => current_user}))
      redirect_to todos_path(:tab => @todo.critical_function), :notice => 'Todo was successfully updated.'
    else
      render 'edit'
    end

  end

end