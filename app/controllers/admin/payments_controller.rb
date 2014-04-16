class Admin::PaymentsController < Admin::AdminController
  before_filter :find_organization
  before_filter :find_payment, only: [:edit, :update, :destroy]

  def index
    @payments = @organization.payments.order('paid_at DESC')
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

  def edit

  end

  def update
    if @payment.update_attributes(payment_params)
      redirect_to({action: 'index'}, notice: 'Updated payment.')
    else
      render 'edit'
    end
  end

  def destroy
    if @payment.destroy
      redirect_to({action: 'index'}, notice: 'Deleted payment.')
    else
      redirect_to({action: 'index'}, notice: "Can't delete payment.")
    end
  end

  private

  def find_organization
    @organization = Organization.find(params[:organization_id])
  end

  def find_payment
    @payment = @organization.payments.find(params[:id])
  end

  def payment_params
    params.require(:payment).permit(
      :paid_at_date,
      :paid_at_time,
      :discount_code_id,
      :amount,
      :transaction_id,
      :account_type,
      :routing_number,
      :account_number
    )
  end
end
