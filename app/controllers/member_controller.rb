class MemberController < ApplicationController

  def index
    @todos = current_org.todos
  end

end