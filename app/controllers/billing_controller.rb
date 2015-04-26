class BillingController < ApplicationController
  skip_before_filter :authenticate!, except: [:show, :cancel]
  before_filter :require_organization
  before_filter :require_subscription, except: [:new, :create, :get_discount, :show]
  before_filter :executives_only, only: [:show, :cancel]

  UNSPECIFIED_ERROR_MESSAGE =
    "There was a problem processing your request. " +
    "Please check your billing address and payment information and try again."
  after_filter :report_failed_transaction, only: [:create, :update]

  def new
    @page = Page.find_by_slug('billing') #rescue OpenStruct(:title => 'Billing', :body => 'Body', :slug => 'Billing')

    if updatable?(current_org.subscription)
      return redirect_to edit_billing_path
    end

    start_amount = PaymentVariable.float_value("starting_amount_in_cents")
    regular_amount = PaymentVariable.float_value("regular_amount_in_cents")

    @subscription = AuthorizeNetSubscription.new(
      organization_id: @organization.id,
      starting_amount_in_cents: start_amount,
      regular_amount_in_cents: regular_amount
    )

    if current_org.active_subscription
      @subscription.copy_billing_info_from(current_org.active_subscription)
    end

    if session[:discount_code]
      d = DiscountCode.find_by_discount_code(session[:discount_code])
      if d
        @subscription.discount_code_id = d.id
        @subscription.validate_discount_code!
      end
    end
  end

  def get_discount
    d = DiscountCode.find_by_discount_code(params[:code])
    subscription = AuthorizeNetSubscription.new
    
    if d
      session[:discount_code] = params[:code]
      subscription.discount_code_id = d.id
      subscription.validate_discount_code!
    end

    render json: {
      code_id: (d.id rescue ""),
      good: !d.nil?,
      start: subscription.starting_amount_in_cents,
      regular: subscription.regular_amount_in_cents
    }
  end
  
  def create
    @subscription = AuthorizeNetSubscription.new
    set_subscription_attributes

    if @organization.subscriptions << @subscription
      session[:discount_code] = nil
      redirect_to "/"
    else
      flash.now[:notice] = UNSPECIFIED_ERROR_MESSAGE
      render 'new'
    end
  end

  def edit
    return redirect_to action: 'new' unless updatable?(@subscription)
    
    if params[:code]
      d = DiscountCode.find_by_discount_code(params[:code])
      if d
        @subscription.discount_code_id = d.id
        @subscription.validate_discount_code!
      end
    end
  end

  def update
    return redirect_to action: 'new' unless updatable?(@subscription)

    set_subscription_attributes

    if @subscription.save
      session[:discount_code] = nil
      redirect_to billing_path
    else
      flash.now[:notice] = UNSPECIFIED_ERROR_MESSAGE
      render 'edit'
    end
  end
  
  def show
    find_subscription
  end

  def cancel
    if @subscription.cancel(role: :organization, canceler: current_user)
      @subscription.organization.update_attributes!(active: false)
      reset_session
      redirect_to :root, notice: "You have successfully cancelled your subscription.  Thanks for using ArtsReady!"
    else
      redirect_to :back, notice: "There was a problem cancelling your subscription.  Please contact ArtsReady for assistance."
    end
  end

  private

  def require_organization
    @organization = current_org
    redirect_to "/", notice: "Please contact ArtsReady for sign-in assistance." unless @organization
  end

  def find_subscription
    @subscription = current_org.subscription
  end

  def require_subscription
    find_subscription
    redirect_to :back unless @subscription
  end

  def executives_only
    unless current_user.is_executive?
      redirect_to "/profile",
        notice: "You don't have access to that.  Please contact your administrator"
    end
  end

  def report_failed_transaction
    transaction = @subscription.failed_transaction

    if transaction
      Airbrake.notify_or_ignore(nil,
        error_message: 'ARB response',
        parameters: {
          response: transaction.response.inspect.
            gsub(/([0-9]{2})[0-9]{10}[0-9]*/, '0x\1L0NGNUMB3R'),
        }
      )

      AdminMailer.payment_submission_error(
        @subscription, current_user
      ).deliver
    end
  end

  def updatable?(subscription)
    subscription && subscription.automatic? && !subscription.past_due?
  end

  def set_subscription_attributes
    return if !@subscription

    subscription_params = params[:subscription]

    @subscription.attributes = {
      billing_first_name: subscription_params[:billing_first_name],
      billing_last_name:  subscription_params[:billing_last_name],
      billing_address:    subscription_params[:billing_address],
      billing_city:       subscription_params[:billing_city],
      billing_state:      subscription_params[:billing_state],
      billing_zipcode:    subscription_params[:billing_zipcode],
      billing_email:      subscription_params[:billing_email],
      billing_phone_number: subscription_params[:billing_phone_number],
      payment_type:       subscription_params[:payment_type]
    }

    if @subscription.new_record?
      @subscription.attributes = {
        starting_amount_in_cents:
          PaymentVariable.float_value("starting_amount_in_cents"),
        regular_amount_in_cents:
          PaymentVariable.float_value("regular_amount_in_cents")
      }
    end

    if session[:discount_code]
      begin
        d = DiscountCode.find(subscription_params[:discount_code_id])
        @subscription.discount_code_id = d.id
        @subscription.validate_discount_code!
      rescue Exception => e
        # do nothing
      end
    end

    if @subscription.payment_type == "cc"
      @subscription.number       = subscription_params[:number]
      @subscription.ccv          = subscription_params[:ccv]
      @subscription.expiry_month = subscription_params[:expiry_month]
      @subscription.expiry_year  = subscription_params[:expiry_year]
    elsif @subscription.payment_type == "bank"
      @subscription.account_type   = subscription_params[:account_type].downcase
      @subscription.bank_name      = subscription_params[:bank_name]
      @subscription.routing_number = subscription_params[:routing_number]
      @subscription.account_number = subscription_params[:account_number]
    else
      # payment type is invalid, let `save` take care of it
    end
  end
end
