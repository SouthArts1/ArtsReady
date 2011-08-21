class CrisesController < ApplicationController

  def new
    @crisis = current_org.crises.build(:user_id => current_user.id)
  end
  
  def edit
    @crisis = current_org.crisis
  end

  def show
    @crisis = Crisis.find(params[:id])
  end

  def update
    if @current_org.crisis.update_attributes(params[:crisis])
      redirect_to crisis_path(current_org.crisis), :notice => "Crisis updated"
    else
      redirect_to crisis_path(current_org.crisis), :notice => "Problem updating your crisis"
    end
  end
  
  def create
    @crisis=current_org.crises.create(params[:crisis])
    @crisis.user = current_user
    if @crisis.save
      redirect_to dashboard_path, :notice => 'Crisis declared!'
    else
      redirect_to dashboard_path, :notice => 'Crisis could not be declared'
    end
  end

  def destroy
    if current_org.crisis.resolve_crisis!
      redirect_to dashboard_path, :notice => 'Crisis resolved!'
    else
      redirect_to dashboard_path, :notice => 'Crisis could not be resolved'
    end
  end

end