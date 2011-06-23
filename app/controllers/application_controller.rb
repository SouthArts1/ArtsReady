class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate!
  
  helper_method :current_user, :user_signed_in?, :current_org
    
  def authenticate!(*args)
    redirect_to :sign_in, :notice => 'You must sign in to access that part of the application.' unless user_signed_in?
  end
  
  private  
  def current_user  
    @current_user ||= User.find(session[:user_id]) if session[:user_id]  
  end
  
  def current_org
    @current_org ||= current_user.organization
  end
  
  def user_signed_in?  
    (current_user.present? && current_org.active?) rescue false
  end
  
  
end
