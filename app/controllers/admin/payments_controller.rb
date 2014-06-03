class Admin::PaymentsController < Admin::AdminController
  before_filter :find_organization
  before_filter :find_payment, only: [:edit, :update, :destroy]

  def index
    @events = @organization.subscription_events.
      includes(:payment).
      order('happened_at DESC') # TODO: test table order
  end

  def new
    @event = @organization.subscription_events.build
  end

  def create
    @event = @organization.subscription_events.build(event_params)

    if @event.save
      redirect_to({action: 'index'}, notice: 'Saved new note.')
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    if @payment.update_attributes(event_params)
      redirect_to({action: 'index'}, notice: 'Updated note.')
    else
      render 'edit'
    end
  end

  def destroy
    if @payment.destroy
      redirect_to({action: 'index'}, notice: 'Deleted note.')
    else
      redirect_to({action: 'index'}, notice: "Can't delete note.")
    end
  end

  private

  def find_payment
    @payment = @organization.payments.find(params[:id])
  end

  def event_params
    params.require(:subscription_event).permit(
      :happened_at_date,
      :happened_at_time,
      :notes,
      :payment_attributes => [
        :extend_subscription,
        :discount_code_id,
        :amount,
        :transaction_id,
        :account_type,
        :routing_number,
        :account_number,
        :check_number
      ]
    )
  end
end
