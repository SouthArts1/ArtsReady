class Admin::SubscriptionEventsController < Admin::AdminController
  before_filter :find_organization
  before_filter :find_event, only: [:edit, :update, :destroy]

  def index
    @events = @organization.subscription_events.
      includes(:payment).
      order('happened_at DESC') # TODO: test table order
  end

  def new
    @event = @organization.subscription_events.build
    @event.prepare_for_editing
  end

  def create
    @event = @organization.subscription_events.build(event_params)

    if @event.save
      redirect_to({action: 'index'}, notice: 'Saved new note.')
    else
      @event.prepare_for_editing
      render 'new'
    end
  end

  def edit
    @event.prepare_for_editing
  end

  def update
    if @event.update_attributes(event_params)
      redirect_to({action: 'index'}, notice: 'Updated note.')
    else
      @event.prepare_for_editing
      render 'edit'
    end
  end

  def destroy
    if @event.destroy
      redirect_to({action: 'index'}, notice: 'Deleted note.')
    else
      redirect_to({action: 'index'}, notice: "Can't delete note.")
    end
  end

  private

  def find_event
    @event = @organization.subscription_events.find(params[:id])
  end

  def event_params
    params.require(:subscription_event).permit(
      :happened_at_date,
      :happened_at_time,
      :notes,
      :payment_attributes => [
        :id,
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
