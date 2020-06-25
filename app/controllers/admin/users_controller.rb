class Admin::UsersController < Admin::AdminController

  def index
    if params[:organization_id]
      @organization = Organization.find(params[:organization_id])
      @users = @organization.users
      @user = User.new(:organization => @organization)
    else
      @users = User
    end
  end

  def create
    @organization = Organization.find(params[:organization_id])
    @user = @organization.users.new(user_params)
    if @user.save
      UserMailer.welcome(@user).deliver_now
      redirect_to admin_organization_users_path(@organization), :notice => "User created"
    else
      @users = @organization.users
      render :index
    end
  end

  def edit
    @organization = Organization.find(params[:organization_id])
    @user = @organization.users.find(params[:id])
  end

  def update
    @organization = Organization.find(params[:organization_id])
    @user = @organization.users.find(params[:id])

    if @user.update_attributes(user_params)
      redirect_to admin_organization_users_path(@organization), :notice => "User updated"
    else
      redirect_to admin_organization_users_path(@organization), :notice => "Problem updating user"
    end

  end

  def destroy
    @organization = Organization.find(params[:organization_id])
    @user = @organization.users.find(params[:id])
    if @user.update_attribute(:disabled,true)
      logger.info("Admin #{current_user.name} just disabled #{@user.email}")
      redirect_to(admin_organization_users_path(@organization), :notice => 'User was successfully disabled.')
    else
      logger.warn("Admin had trouble disabling #{@user.email}")
      redirect_to(admin_organization_users_path(@organization), :notice => 'Problem disabling user')
    end
  end

  private

  def user_params
    params.require(:user)
      .permit(
        :first_name, :last_name, :email, :disabled
      )
  end
end
