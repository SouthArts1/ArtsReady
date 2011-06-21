class OrganizationsController < ApplicationController

  def edit
    @organization = current_org
  end

  def update
    @organization = current_org

    if @organization.update_attributes(params[:organization])
      redirect_to dashboard_path, :notice => 'Organization was successfully updated.'
    else
      render :action => "edit"
    end
    
  end

end
