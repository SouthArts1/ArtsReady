class MemberController < ApplicationController
  
  before_filter :authenticate!

  def index
    @todos = current_org.todos
  end
  
end
