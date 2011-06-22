class ResourcesController < ApplicationController

  def index
    @resources = current_org.resources.all
  end

  def show
    @resource = current_org.resources.find(params[:id])
  end

  def new
    @resource = current_org.resources.new
  end

  def edit
    @resource = current_org.resources.find(params[:id])
  end

  def create
    @resource = current_org.resources.new(params[:resource])
    if @resource.save
      redirect_to(buddies_profile_path, :notice => 'Resource was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @resource = current_org.resources.find(params[:id])

    if @resource.update_attributes(params[:resource])
      redirect_to(buddies_profile_path, :notice => 'Resource was successfully updated.')
    else
      render :action => "edit"
    end

  end

  def destroy
    @resource = current_org.resources.find(params[:id])
    @resource.destroy
    redirect_to(resources_url)
  end
end
