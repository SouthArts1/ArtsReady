class Admin::AdminController < ApplicationController

  skip_before_filter :authenticate!
  before_filter :authenticate_admin!

  layout "admin"

  helper_method :admin_signed_in?

  def authenticate_admin!(*args)
    redirect_to root_url unless admin_signed_in?
  end

  private
  def admin_signed_in?
    current_user.present? && current_user.admin?
  end
end