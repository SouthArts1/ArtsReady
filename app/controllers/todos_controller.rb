class TodosController < ApplicationController
  
  def index
    @todos = current_org.todos
    @todo = current_org.todos.new
  end
  
  def show
    @todo = current_org.todos.find(params[:id])
  end

  def edit
    @todo = current_org.todos.find(params[:id])
  end
  
  def create
    @todo = current_org.todos.new(params[:todo])

    if @todo.save
      redirect_to todos_path, :notice => 'Post was successfully created.'
    else
      render :action => "index"
    end

  end
  
  def update
  end
  
end
