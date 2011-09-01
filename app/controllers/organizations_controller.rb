class OrganizationsController < ApplicationController

  skip_before_filter :authenticate!, :only => [:new, :create]

  def new
    @organization = Organization.new
  end
  
  def create
    user = params[:organization][:users_attributes][0]
    logger.debug(user.inspect)
    params[:organization].merge({:contact_name => "#{user[:first_name]} #{user[:last_name]}", :contact_email => user[:emails]})
    @organization = Organization.new(params[:organization])
    if @organization.save
      redirect_to welcome_path, :notice => "Signed up!"
    else
      render "new"
    end    
  end
  
  def edit
    @organization = current_org
  end

  def update
    @organization = current_org

    if @organization.update_attributes(params[:organization])
      redirect_to edit_organization_path(current_org), :notice => 'Organization was successfully updated.'
    else
      render 'edit'
    end

  end

end