class CrisesController < ApplicationController
  
  def show
    @crisis = Crisis.find(params[:id])
  end
  
  def create
    if current_org.crises.create
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
