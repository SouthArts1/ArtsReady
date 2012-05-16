class BillingController < ApplicationController
  skip_before_filter :authenticate!, only: [:new, :create]
  def new
    if session[:organization_id] != nil && session[:organization_id] != ""
      @page = Page.find_by_slug('billing') #rescue OpenStruct(:title => 'Billing', :body => 'Body', :slug => 'Billing')
      @organization = Organization.find(session[:organization_id])
      @payment ||= Payment.new({organization_id: @organization.id, billing_first_name: @organization.name, billing_last_name: "", billing_address: @organization.address, billing_city: @organization.city, billing_state: @organization.state, billing_zipcode: @organization.zipcode })
    else 
      redirect_to "/", notice: "Please contact ArtsReady for sign-in assistance."
    end
  end
  
  def create
    obj = params[:payment]
    @organization = Organization.find(obj[:organization_id])
    @payment = Payment.new({organization_id: obj[:organization_id], billing_first_name: obj[:billing_first_name], billing_last_name: obj[:billing_last_name], billing_address: obj[:billing_address], billing_city: obj[:billing_city], billing_state: obj[:billing_state], billing_zipcode: obj[:billing_zipcode],  expiry_month: obj["expiry_month(2i)"], expiry_year: obj["expiry_year(1i)"], starting_amount_in_cents: 30000, regular_amount_in_cents: 22500, payment_type: params[:payment_type]})
    if params[:payment_type] == "cc"
      logger.debug("Payment via CC")
      @payment.number = obj[:number]
      @payment.ccv = obj[:ccv]
    elsif params[:payment_type] == "bank"
      logger.debug("Payment via account")
      @payment.account_type = obj[:account_type].downcase
      @payment.bank_name = obj[:bank_name]
      @payment.routing_number = obj[:routing_number]
      @payment.account_number = obj[:account_number]
    else
      logger.debug("No Payment")
      redirect_to :back, error: "There was a problem processing your request.  Please try again or contact ArtsReady"
    end
    if @payment.save
      @current_user = @organization.managers.first
      session[:user_id] = @current_user.id
      redirect_to "/"
    else
      redirect_to :back, error: "There was a problem processing your request.  Please try again or contact ArtsReady"
    end
  end
  
  def edit
    @payment = Payment.find(params[:id])
    if current_user.organization != @payment.organization
      redirect_to :back, warning: "You cannot access that."
    end
  end
  
  def update
    obj = params[:payment]
    @organization = current_org
    @payment = Payment.find(params[:payment][:id])

    if obj[:number] != ""
      logger.debug("Payment via CC")
      @payment.number = obj[:number]
      @payment.ccv = obj[:ccv]
    elsif obj[:account_number] != ""
      logger.debug("Payment via account")
      @payment.account_type = obj[:account_type].downcase
      @payment.bank_name = obj[:bank_name]
      @payment.routing_number = obj[:routing_number]
      @payment.account_number = obj[:account_number]
    else
      logger.debug("No Payment")
      redirect_to :back, notice: "There was a problem processing your request.  Please try again or contact ArtsReady"
    end
    logger.debug("Try updating")
    if @payment.update_attributes({billing_first_name: obj[:billing_first_name], billing_last_name: obj[:billing_last_name], billing_address: obj[:billing_address], billing_city: obj[:billing_city], billing_state: obj[:billing_state], billing_zipcode: obj[:billing_zipcode],  expiry_month: obj[:expiry_month], expiry_year: obj["expiry_year(1i)"], payment_type: params[:payment_type]})
      logger.debug("G2G")
      redirect_to billing_my_organization_path
    else
      logger.debug("Failed")
      redirect_to :back, error: "There was a problem processing your request.  Please try again or contact ArtsReady"
    end
  end
  
  def my_organization
    @organization = current_org
    @payment = current_org.payment
  end
end
