class Admin::AdminController < ApplicationController
  
  before_filter :authenticate_admin!
  
  def authenticate_admin!(*args)
    redirect_to :dashboard unless admin_signed_in?
  end
  
  private  
  def admin_signed_in?  
    current_user.present? && current_user.admin?
  end
end
