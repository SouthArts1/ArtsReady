class Admin::OrganizationsController < Admin::AdminController

  def index
    @organizations = Organization.all
  end
  
  def edit
    @organization = Organization.find(params[:id])
  end
  
  def update
    @organization = Organization.find(params[:id])

    if @organization.update_attributes(params[:organization])
      redirect_to admin_organizations_path, :notice => "Organization updated"
    else
      redirect_to admin_organizations_path, :notice => "Problem updating organization"
    end

  end
  
  def billing
    @organization = Organization.find(params[:id])
    @payment = @organization.payment
  end
  
  def allow_provisionary_access
    o = Organization.find(params[:id])
    u = o.users.first
    @payment = o.payments.build_provisional
    if @payment.save
      @payment.update_attribute(:billing_email, nil)
      redirect_to :back, :notice => "Provisionary access has been granted"
    else
      redirect_to :back, :notice => "Problem granting access."
    end
  end

  def destroy
    @organization = Organization.find(params[:id])
    if @organization.deletable?
      @organization.destroy
      redirect_to(admin_organizations_path, :notice => 'Organization was successfully destroyed.')
    else
      logger.warn("Admin had trouble destroying #{@organization.name}")
      redirect_to(admin_organizations_path, :notice => 'Problem destroying org')
    end
  end

end
