class OrganizationsController < ApplicationController

  skip_before_filter :authenticate!, :only => [:new, :create]

  def new
    @organization = Organization.new
  end
  
  def create
    user = params[:organization][:users_attributes]['0']
    logger.debug(user.inspect)
    params[:organization].merge!({:contact_name => "#{user[:first_name]} #{user[:last_name]}", :email => user[:email]})
    logger.debug(params[:organization].inspect)
    @organization = Organization.new(organization_params)
    if @organization.save
      session[:user_id] = User.find_by_email(user[:email]).id
      redirect_to new_billing_path, :notice => "Signed up!"
    else
      render "new"
    end    
  end
  
  def edit
    @organization = current_org
  end

  def update
    @organization = current_org

    if @organization.update_attributes(organization_params)
      redirect_to edit_organization_path(current_org), :notice => 'Organization was successfully updated.'
    else
      render 'edit'
    end

  end

  private

  def organization_params
    params.require(:organization).permit(
      :name, :address, :address_additional, :city, :state, :zipcode,
      :email, :phone_number, :fax_number, :contact_name,
      :parent_organization, :subsidizing_organization, :organizational_status,
      :nsic_code, :other_nsic_code,
      :battle_buddy_enabled,
      users_attributes: [
        :first_name, :last_name, :title, :email,
        :password, :password_confirmation,
        :accepted_terms
      ]
    )
  end
end