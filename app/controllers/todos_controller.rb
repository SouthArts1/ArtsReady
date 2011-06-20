class TodosController < ApplicationController
  
  def index
    @todos = current_org.todos
  end
  
end
