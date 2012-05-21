class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate!

  helper_method :current_user, :user_signed_in?, :current_org

  def authenticate!(*args)

    unless user_signed_in?
      msg = 'You must sign in to access that page'
      if (current_user.present? && !current_org.active?) 
        msg = 'Your organization has not been approved or is inactive.' 
        if !current_org.payment
          redirect_to new_billing_path
        else
          redirect_to :sign_in, notice: msg
        end
      end
      if (current_user.present? && current_user.disabled?) 
        msg = 'Your user account is inactive' 
        redirect_to :sign_in, :notice => msg
      end
    end
  end
  
  rescue_from CanCan::AccessDenied do |exception|  
    flash[:error] = "Access denied! #{@current_user.inspect}"  
    redirect_to root_url  
  end

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id] rescue nil
  end

  def current_org
    @current_org ||= current_user.organization || User.find(session[:user_id]).organization
  end

  def user_signed_in?
    (current_user.present? && current_org.active?) rescue false
  end

end