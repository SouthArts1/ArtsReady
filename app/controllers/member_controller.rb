class MemberController < ApplicationController

  def index
    redirect_to crisis_path(current_org.crisis) if current_org.declared_crisis?
    @todos = current_org.todos
  end

end