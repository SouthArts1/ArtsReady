class Admin::PaymentsController < Admin::AdminController
  before_filter :find_organization

  def index
  end

  def new
    @payment = @organization.payments.build
  end

  def create
    @payment = @organization.payments.build(payment_params)

    if @payment.save
      redirect_to({action: 'index'}, notice: 'Saved new payment.')
    else
      render 'new'
    end
  end

  private

  def find_organization
    @organization = Organization.find(params[:organization_id])
  end

  def payment_params
    params.require(:payment).permit(
      :discount_code_id,
      :amount,
      :arb_id,
      :account_type,
      :routing_number,
      :account_number
    )
  end
end
