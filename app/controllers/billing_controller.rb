class BillingController < ApplicationController
  skip_before_filter :authenticate!, only: [:new, :create, :get_discount]
  UNSPECIFIED_ERROR_MESSAGE =
    "There was a problem processing your request. " +
    "Please check your billing address and payment information and try again."
  after_filter :report_failed_transaction, only: [:create, :update]

  def new
    if current_org || (session[:organization_id] != nil && session[:organization_id] != "")
      @page = Page.find_by_slug('billing') #rescue OpenStruct(:title => 'Billing', :body => 'Body', :slug => 'Billing')
      if current_org
        @organization = current_org
      else
        @organization = Organization.find(session[:organization_id])
      end 
      
      start_amount = PaymentVariable.float_value("starting_amount_in_cents")
      regular_amount = PaymentVariable.float_value("regular_amount_in_cents")
      
      if current_org.subscription && current_org.subscription.automatic?
        return redirect_to edit_billing_path
      else
        @subscription = AuthorizeNetSubscription.new(
          organization_id: @organization.id,
          starting_amount_in_cents: start_amount,
          regular_amount_in_cents: regular_amount
        )

        if current_org.active_subscription
          @subscription.copy_billing_info_from(current_org.active_subscription)
        end
      end
            
      if session[:discount_code]
        d = DiscountCode.find_by_discount_code(session[:discount_code])
        if d
          @subscription.discount_code_id = d.id
          @subscription.validate_discount_code!
        end
      end
    else 
      redirect_to "/", notice: "Please contact ArtsReady for sign-in assistance."
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
    @organization = current_org
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
    @organization = current_org
    @subscription = @organization.subscription
    return redirect_to :back unless @subscription
    return redirect_to action: 'new' unless @subscription.automatic?
    
    if params[:code]
      d = DiscountCode.find_by_discount_code(params[:code])
      if d
        @subscription.discount_code_id = d.id
        @subscription.validate_discount_code!
      end
    end
  end
  
  def update
    @organization = current_org
    @subscription = @organization.subscription
    unless @subscription && @subscription.automatic?
      return redirect_to(:back, notice: UNSPECIFIED_ERROR_MESSAGE)
    end

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
    redirect_to "/profile", notice: "You don't have access to that.  Please contact your administrator." unless current_user.is_executive?
    @organization = current_org
    @subscription = current_org.subscription
  end
  
  def cancel
    # FIXME: move admin functionality to admin controller
    if current_user.is_admin? && params[:id] != nil
      @subscription = Organization.find(params[:id]).subscription
    else
      @subscription = current_org.subscription
      redirect_to "/profile", notice: "You don't have access to that.  Please contact your administrator" and return unless current_user.is_executive?
    end
    
    if @subscription.cancel
      if current_user.is_admin?
        redirect_to "/admin/organizations", notice: "You've successfully cancelled the subscription."
      else
        redirect_to :dashboard, notice: "You have successfully cancelled your subscription.  Thanks for using ArtsReady!"
      end
    else 
      redirect_to :back, notice: "There was a problem cancelling your subscription.  Please contact ArtsReady for assistance."
    end
  end

  private

  def report_failed_transaction
    response = @subscription.failed_transaction_response

    if response
      Airbrake.notify_or_ignore(nil,
        error_message: 'ARB response',
        parameters: {
          response: response.inspect.gsub(/([0-9]{2})[0-9]{10}[0-9]*/, '0x\1L0NGNUMB3R'),
          response_response: (response.response rescue nil).inspect
        }
      )

      AdminMailer.payment_submission_error(
        @subscription, current_user
      ).deliver
    end
  end

  private

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
