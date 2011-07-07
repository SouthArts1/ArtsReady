class OrganizationsController < ApplicationController

  def edit
    @organization = current_org
  end

  def update
    @organization = current_org

    if @organization.update_attributes(params[:organization])
      redirect_to dashboard_path, :notice => 'Organization was successfully updated.'
    else
      render 'edit'
    end

  end
  
  def declare_crisis
    if current_org.update_attribute(:declared_crisis,true)
      redirect_to dashboard_path, :notice => 'Crisis declared!'
    else
      redirect_to dashboard_path, :notice => 'Crisis could not be declared'
    end
  end
  
  def resolve_crisis
    if current_org.update_attribute(:declared_crisis,false)
      redirect_to dashboard_path, :notice => 'Crisis resolved!'
    else
      redirect_to dashboard_path, :notice => 'Crisis could not be resolved'
    end
  end

end