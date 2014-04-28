class Admin::BillingController < Admin::AdminController
  before_filter :find_organization
  before_filter :find_subscription

  def edit
  end

  def update
    if @subscription.update_attributes(subscription_params)
      redirect_to admin_organization_billing_path(@organization)
    else
      flash.now[:error] = 'Error updating subscription'
      render 'edit'
    end
  end

  private

  def find_subscription
    @subscription = @organization.subscription
  end

  def subscription_params
    params.require(:subscription).permit(
      :next_billing_date,
      :regular_amount
    ).merge(:skip_authorization => true)
  end
end
