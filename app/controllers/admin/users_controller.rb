class Admin::UsersController < Admin::AdminController

  def index
    @organization = Organization.find(params[:organization_id])
    @users = @organization.users
  end
  
  def create
    @organization = Organization.find(params[:organization_id])
    @user = @organization.users.new(params[:user])
    if @user.save
      UserMailer.welcome(@user).deliver
      redirect_to admin_organization_users_path(@organization), :notice => "User created"
    else
      redirect_to admin_organization_users_path(@organization), :notice => "Problem creating user"
    end
    
  end

end
