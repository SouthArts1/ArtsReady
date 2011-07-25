class UsersController < ApplicationController

  skip_before_filter :authenticate!, :only => [:new, :create]

  def new
    @user = User.new
    @user.build_organization
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect_to welcome_path, :notice => "Signed up!"
    else
      render "new"
    end
  end
  
  def edit
    @user = current_user
  end
  
  def index
    @users = current_org.users
  end

end