class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate!

  helper_method :current_user, :user_signed_in?, :current_org

  def authenticate!(*args)
    unless user_signed_in?
      msg = 'You must sign in to access that page'
      if (current_user.present? && !current_org.active?) 
        msg = 'Your organization has not been approved or is inactive.' 
        if !current_org.subscription
          redirect_to new_billing_path
        else
          redirect_to :sign_in, notice: msg
        end
      elsif (current_user.present? && current_user.disabled?) 
        msg = 'Your user account is inactive' 
        redirect_to :sign_in, :notice => msg
      else
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
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def current_org
    @current_org ||= current_user.try(:organization)
  end

  def user_signed_in?
    current_org.try(:active?)
  end

end
