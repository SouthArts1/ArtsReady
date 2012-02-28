class UsersController < ApplicationController

  before_filter :require_manager, :except => [:index, :profile]
  
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
    #TWO QUICK TWEAKS FOR #20307113
    redirect_to edit_organization_user_path(current_org,@user), :notice => "Permission denied" if params[:user].has_key?(:admin)
    redirect_to edit_organization_user_path(current_org,@user), :notice => "Permission denied" if params[:user].has_key?(:role) && current_user.role == 'reader'
    
    if @user.update_attributes(params[:user])
      redirect_to edit_organization_user_path(current_org,@user), :notice => "User updated"
    else
      logger.debug(@user.errors.inspect)
      redirect_to edit_organization_user_path(current_org,@user), :notice => "Problem updating user"
    end

  end
  
  def index
    @users = current_org.users
  end
  
  def profile
    @user = current_user
    render :edit
  end
  
  def destroy
    @user = current_org.users.find(params[:id])
    if @user.update_attribute(:disabled,true)
      logger.info("#{current_user.name} just disabled #{@user.email}")
      redirect_to(organization_users_path(current_org), :notice => 'User was successfully disabled.')
    else
      logger.warn("Had trouble disabling #{@user.email}")
      redirect_to(organization_users_path(current_org), :notice => 'Problem disabling user')
    end
  end
  
  private
  
  def require_manager
    redirect_to :root, :notice => 'You must be a manager to do that' unless current_user.role == 'manager'
  end
  

end