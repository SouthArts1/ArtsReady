class UsersController < ApplicationController

  skip_before_filter :authenticate!
  
  def new
    @user = User.new
    @user.build_organization
  end

  def create
    @user = User.new(params[:user])  
    if @user.save
      session[:user_id] = @user.id  
      redirect_to dashboard_path, :notice => "Signed up!"  
    else  
      render "new"  
    end  
  end

end
