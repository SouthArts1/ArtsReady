class CrisesController < ApplicationController

  def index
    @crises = current_org.crises.resolved.order('resolved_on DESC')
  end
  
  def new
    @crisis = current_org.crises.build(:user_id => current_user.id)
    @crisis.visibility = 'public' if current_org.battle_buddies.empty?
  end
  
  def edit
    @crisis = current_org.crisis
  end

  def show
    @crisis = Crisis.find(params[:id])
  end
  
  def summary
    @crisis = current_org.crises.find(params[:id])
  end

  def update
    #TODO fix this hack
    if params[:buddy_list].present?
      buddy_list = params[:buddy_list].collect {|i| i.to_i}.join(',')
      params[:crisis].merge!(:buddy_list => buddy_list)
    end
    if @current_org.crisis.update_attributes(crisis_params)
      redirect_to crisis_path(current_org.crisis), :notice => "Crisis updated"
    else
      redirect_to crisis_path(current_org.crisis), :notice => "Problem updating your crisis"
    end
  end
  
  def create
    #TODO fix this hack
    if params[:buddy_list].present?
      buddy_list = params[:buddy_list].collect {|i| i.to_i}.join(',')
      params[:crisis].merge!(:buddy_list => buddy_list)
    end
    @crisis = current_org.crises.create(crisis_params)
    @crisis.user = current_user
    if @crisis.save
      redirect_to dashboard_path, :notice => 'Crisis declared!'
    else
      render :action => "new"
    end
  end

  def destroy
    if current_org.crisis.resolve_crisis!
      redirect_to dashboard_path, :notice => 'Crisis resolved!'
    else
      redirect_to dashboard_path, :notice => 'Crisis could not be resolved'
    end
  end

  private

  def crisis_params
    params.require(:crisis).permit(
      :description,
      :visibility,
      buddy_list: []
    )
  end

end
