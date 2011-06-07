class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user, :user_signed_in?  
    
  def authenticate!(*args)
    redirect_to :sign_in unless user_signed_in?
  end
  
  private  
  def current_user  
    @current_user ||= User.find(session[:user_id]) if session[:user_id]  
  end
  
  def user_signed_in?  
    current_user.present?
  end
  
  def current_org
    @organization ||= current_user.organization
  end
  
  
end
