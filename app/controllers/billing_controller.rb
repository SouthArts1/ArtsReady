class BillingController < ApplicationController
  skip_before_filter :authenticate!, only: [:new, :create, :get_discount]
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
    obj = params[:payment]
    @organization = Organization.find(obj[:organization_id])
    
    start_amount = PaymentVariable.find_by_key("starting_amount_in_cents").value.to_f
    regular_amount = PaymentVariable.find_by_key("regular_amount_in_cents").value.to_f
    
    @payment = Payment.new({organization_id: obj[:organization_id], billing_first_name: obj[:billing_first_name], billing_last_name: obj[:billing_last_name], billing_address: obj[:billing_address], billing_city: obj[:billing_city], billing_state: obj[:billing_state], billing_zipcode: obj[:billing_zipcode], billing_email: obj[:billing_email], expiry_month: obj["expiry_month"], expiry_year: obj["expiry_year(1i)"], payment_type: params[:payment_type], starting_amount_in_cents: start_amount, regular_amount_in_cents: regular_amount})
    
    if session[:discount_code]
      begin
        d = DiscountCode.find(obj[:discount_code_id])
        @payment.discount_code_id = d.id
        @payment.validate_discount_code!
      rescue Exception => e
        # do nothing
      end
    end
    if params[:payment_type] == "cc"
      @payment.payment_type = "cc"
      @payment.number = obj[:number]
      @payment.ccv = obj[:ccv]
    elsif params[:payment_type] == "bank"
      @payment.payment_type = "bank"
      @payment.account_type = obj[:account_type].downcase
      @payment.bank_name = obj[:bank_name]
      @payment.routing_number = obj[:routing_number]
      @payment.account_number = obj[:account_number]
    else
      puts("PAYMENT TYPE #{params[:payment_type].inspect}")
      return redirect_to :back, notice: "There was a problem processing your request.  Please check your billing address and payment information and try again."
    end
    if @payment.save
      session[:discount_code] = nil
      @current_user = @organization.managers.first
      session[:user_id] = @current_user.id
      return redirect_to "/" 
    else
      puts("PAYMENT ERRORS: #{@payment.errors.inspect}")
      return redirect_to :back, notice: "There was a problem processing your request.  Please check your billing address and payment information and try again."
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
    obj = params[:payment]
    @organization = current_org
    
    start_amount = PaymentVariable.find_by_key("starting_amount_in_cents").value.to_f
    regular_amount = PaymentVariable.find_by_key("regular_amount_in_cents").value.to_f
    
    @payment = current_org.payment
    redirect_to :back, notice: "There was a problem processing your request.  Please check your billing address and payment information and try again." unless @payment
    
    if session[:discount_code]
      begin
        d = DiscountCode.find_by_discount_code(session[:discount_code])
        @payment.discount_code_id = d.id
        @payment.validate_discount_code!
      rescue Exception => e
        # do nothing
      end
    end
    
    if params[:payment_type] == "cc"
      @payment.number = obj[:number]
      @payment.ccv = obj[:ccv]
      @payment.payment_type = "cc"
    elsif params[:payment_type] == "bank"
      @payment.account_type = obj[:account_type].downcase
      @payment.bank_name = obj[:bank_name]
      @payment.routing_number = obj[:routing_number]
      @payment.account_number = obj[:account_number]
      @payment.payment_type = "bank"
    else
      return redirect_to :back, notice: "There was a problem processing your request.  Please check your billing address and payment information and try again."
    end
    
    @payment.billing_first_name = obj[:billing_first_name] 
    @payment.billing_last_name = obj[:billing_last_name] 
    @payment.billing_address = obj[:billing_address] 
    @payment.billing_city = obj[:billing_city] 
    @payment.billing_state = obj[:billing_state] 
    @payment.billing_zipcode = obj[:billing_zipcode]  
    @payment.billing_email = obj[:billing_email]  
    @payment.expiry_month = obj[:expiry_month] 
    @payment.expiry_year = obj["expiry_year(1i)"]
    
    if @payment.save
      session[:discount_code] = nil
      redirect_to billing_path
    else
      redirect_to :back, notice: "There was a problem processing your request.  Please check your billing address and payment information and try again."
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
end
