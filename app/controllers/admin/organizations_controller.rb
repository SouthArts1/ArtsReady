class Admin::OrganizationsController < Admin::AdminController

  def index
    @organizations = Organization.all
  end

  def update
    @organization = Organization.find(params[:id])
    
    if @organization.update_attributes(params[:organization])  
      redirect_to admin_organizations_path, :notice => "Organization approved"  
    else  
      redirect_to admin_organizations_path, :notice => "Problem approving organization"  
    end  
    
  end
  
end