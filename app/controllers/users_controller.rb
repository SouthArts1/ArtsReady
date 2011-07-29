class UsersController < ApplicationController

  def create
    @user = current_org.users.new(params[:user])
    if @user.save
      redirect_to organization_users_path(current_org), :notice => "User created"
    else
      redirect_to organization_users_path(current_org), :notice => "Problem creating user"
    end
  end
  
  def edit
    @user = current_org.users.find(params[:id])
  end
  
  def update
    @user = current_org.users.find(params[:id])

    if @user.update_attributes(params[:user])
      redirect_to edit_organization_user_path(current_org,@user), :notice => "User updated"
    else
      redirect_to edit_organization_user_path(current_org,@user), :notice => "Problem updating user"
    end

  end
  
  
  def index
    @users = current_org.users
  end

end