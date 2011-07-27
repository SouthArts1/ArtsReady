class UsersController < ApplicationController

  def create
    @user = current_org.users.new(params[:user])
    if @user.save
      UserMailer.welcome(@user).deliver
      redirect_to organization_users_path(current_org), :notice => "User created"
    else
      redirect_to organization_users_path(current_org), :notice => "Problem creating user"
    end
  end
  
  def edit
    @user = current_org.users.find(params[:id])
  end
  
  def index
    @users = current_org.users
  end

end