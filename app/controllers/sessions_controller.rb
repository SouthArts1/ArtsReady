class SessionsController < ApplicationController

  skip_before_filter :authenticate!, :except => [:destroy]

  def new
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user && !user.disabled?
      session[:user_id] = user.id
      logger.debug(user.inspect)
      if user.admin?
        redirect_to admin_dashboard_path, :notice => "Logged in!"
      else
        redirect_to dashboard_path, :notice => "Logged in!"
      end
    elsif user && user.disabled?
      flash[:warning] = "Account has been disabled by an administrator"
      render "new"
    else
      flash[:warning] = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    reset_session
    redirect_to root_url, :notice => "Logged out!"
  end

end