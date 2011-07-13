class MemberController < ApplicationController

  def index
    
    redirect_to crisis_console_path if current_org.declared_crisis?
    @todos = current_org.todos
  end

end