class BillingController < ApplicationController
  skip_before_filter :authenticate!, only: [:new, :create, :get_discount]
  UNSPECIFIED_ERROR_MESSAGE =
    "There was a problem processing your request. " +
    "Please check your billing address and payment information and try again."

  def new
    if current_org || (session[:organization_id] != nil && session[:organization_id] != "")
      @page = Page.find_by_slug('billing') #rescue OpenStruct(:title => 'Billing', :body => 'Body', :slug => 'Billing')
      if current_org
        @organization = current_org
      else
        @organization = Organization.find(session[:organization_id])
      end 
      
      start_amount = PaymentVariable.find_by_key("starting_amount_in_cents").value.to_f
      regular_amount = PaymentVariable.find_by_key("regular_amount_in_cents").value.to_f
      
      if current_org.payments.last
        return redirect_to edit_billing_path
      else
        @payment = Payment.new({organization_id: @organization.id, starting_amount_in_cents: start_amount, regular_amount_in_cents: regular_amount })
      end
            
      if session[:discount_code]
        d = DiscountCode.find_by_discount_code(session[:discount_code])
        if d
          @payment.discount_code_id = d.id
          @payment.validate_discount_code!
        end
      end
    else 
      redirect_to "/", notice: "Please contact ArtsReady for sign-in assistance."
    end
  end
  
  def get_discount
    d = DiscountCode.find_by_discount_code(params[:code])
    start_amount = PaymentVariable.find_by_key("starting_amount_in_cents").value.to_f
    regular_amount = PaymentVariable.find_by_key("regular_amount_in_cents").value.to_f
    payment = Payment.new({starting_amount_in_cents: start_amount, regular_amount_in_cents: regular_amount})
    
    if d
      session[:discount_code] = params[:code]
      payment.discount_code_id = d.id
      payment.validate_discount_code!
    end
    render json: {
      code_id: (d.id rescue ""),
      good: !d.nil?,
      start: payment.starting_amount_in_cents,
      regular: payment.regular_amount_in_cents
    } and return
  end
  
  def create
    @organization = current_org
    @payment = @organization.payments.build
    set_payment_attributes

    if @payment.save
      session[:discount_code] = nil
      redirect_to "/"
    else
      redirect_to :back, notice: UNSPECIFIED_ERROR_MESSAGE
    end
  end

  def edit
    @organization = current_org
    @payment = @organization.payment
    return redirect_to :back unless @payment
    
    if params[:code]
      d = DiscountCode.find_by_discount_code(params[:code])
      if d
        @payment.discount_code_id = d.id
        @payment.validate_discount_code!
      end
    end
  end
  
  def update
    @organization = current_org
    @payment = @organization.payment
    set_payment_attributes

    return redirect_to(:back, notice: UNSPECIFIED_ERROR_MESSAGE) if !@payment

    if @payment.save
      session[:discount_code] = nil
      redirect_to billing_path
    else
      redirect_to :back, notice: UNSPECIFIED_ERROR_MESSAGE
    end
  end
  
  def show
    redirect_to "/profile", notice: "You don't have access to that.  Please contact your administrator." unless current_user.is_executive?
    @organization = current_org
    @payment = current_org.payment
  end
  
  def cancel
    if current_user.is_admin? && params[:id] != nil
      @payment = Organization.find(params[:id]).payment
    else
      @payment = current_org.payment
      redirect_to "/profile", notice: "You don't have access to that.  Please contact your administrator" and return unless current_user.is_executive?
    end
    
    if @payment.cancel
      if current_user.is_admin?
        redirect_to "/admin/organizations", notice: "You've successfully cancelled the subscription."
      else
        redirect_to "/", notice: "You have successfully cancelled your subscription.  Thanks for using ArtsReady!"
      end
    else 
      redirect_to :back, notice: "There was a problem cancelling your subscription.  Please contact ArtsReady for assistance."
    end
  end

  private

  def set_payment_attributes
    return if !@payment

    payment_params = params[:payment]

    @payment.attributes = {
      billing_first_name: payment_params[:billing_first_name],
      billing_last_name:  payment_params[:billing_last_name],
      billing_address:    payment_params[:billing_address],
      billing_city:       payment_params[:billing_city],
      billing_state:      payment_params[:billing_state],
      billing_zipcode:    payment_params[:billing_zipcode],
      billing_email:      payment_params[:billing_email],
      billing_phone_number: payment_params[:billing_phone_number]
    }

    if @payment.new_record?
      @payment.attributes = {
        starting_amount_in_cents:
          PaymentVariable.find_by_key("starting_amount_in_cents").value.to_f,
        regular_amount_in_cents:
          PaymentVariable.find_by_key("regular_amount_in_cents").value.to_f
      }
    end

    if session[:discount_code]
      begin
        d = DiscountCode.find(payment_params[:discount_code_id])
        @payment.discount_code_id = d.id
        @payment.validate_discount_code!
      rescue Exception => e
        # do nothing
      end
    end

    @payment.payment_type = params[:payment_type]

    if @payment.payment_type == "cc"
      @payment.number       = payment_params[:number]
      @payment.ccv          = payment_params[:ccv]
      @payment.expiry_month = payment_params[:expiry_month]
      @payment.expiry_year  = payment_params[:expiry_year]
    elsif @payment.payment_type == "bank"
      @payment.account_type   = payment_params[:account_type].downcase
      @payment.bank_name      = payment_params[:bank_name]
      @payment.routing_number = payment_params[:routing_number]
      @payment.account_number = payment_params[:account_number]
    else
      # payment type is invalid, let `save` take care of it
    end
  end
end
