class Payment < ActiveRecord::Base
  belongs_to :organization
  
  attr_accessor :amount, :number, :ccv, :bank_name, :account_type, :routing_number, :account_number, :payment_type
  
  before_create :create_and_process_subscription
  before_update :update_arb_subscription
  
  def is_active?
    return self.active?
  end
  
  def days_left_until_rebill
    (((self.start_date + 365.days) - (Time.now)).to_i / (24 * 60 * 60)) rescue 0
  end
  
  def amount=
    return self.amount_in_cents * 100
  end
  
  def amount
    return self.amount_in_cents.to_f / 100
  end
  
  def get_expiry(expiry_month, expiry_year)
    expiry_month = "0" + expiry_month.to_s if expiry_month.to_s.length < 2
    expiry_year = expiry_year.to_s.split("")[2] + expiry_year.to_s.split("")[3]
    return expiry_month.to_s + expiry_year.to_s
  end
  
  def build_subscription_object(payment)
    sub = AuthorizeNet::ARB::Subscription.new(
      name: "ArtsReady Yearly Subscription",
      length: 365, 
      unit: AuthorizeNet::ARB::Subscription::IntervalUnits::DAY,
      start_date: self.start_date,
      total_occurrences: 9999,
      amount: self.regular_amount_in_cents.to_f / 100,
      trial_amount: self.starting_amount_in_cents.to_f / 100,
      trial_occurrences: 1,
      description: "#{payment.organization.name} subscription for ArtsReady to help arts organizations plan for the best, and prepare for the worst",
      billing_address: {
        first_name: (payment.billing_first_name rescue ""),
        last_name: (payment.billing_last_name rescue ""),
        company: (payment.organization.name rescue ""),
        address: (payment.billing_address rescue payment.organization.address),
        city: (payment.billing_city rescue payment.organization.city),
        state: (payment.billing_state rescue payment.organization.state),
        zip: (payment.zipcode rescue payment.organization.zipcode),
        country: "United States"
      }
    )
    return sub
  end
  
  def build_subscription_object_for_update(payment)
    sub = AuthorizeNet::ARB::Subscription.new(
      subscription_id: self.arb_id,
      billing_address: {
        first_name: (payment.billing_first_name rescue ""),
        last_name: (payment.billing_last_name rescue ""),
        company: (payment.organization.name rescue ""),
        address: (payment.billing_address rescue payment.organization.address),
        city: (payment.billing_city rescue payment.organization.city),
        state: (payment.billing_state rescue payment.organization.state),
        zip: (payment.zipcode rescue payment.organization.zipcode),
        country: "United States"
      }
    )
    return sub
  end
  
  def billing_address_for_transaction
    return {
      first_name: (self.billing_first_name rescue ""),
      last_name: (self.billing_last_name rescue ""),
      company: (self.organization.name rescue self.billing_name),
      address: (self.billing_address rescue self.organization.address),
      city: (self.billing_city rescue self.organization.city),
      state: (self.billing_state rescue self.organization.state),
      zip: (self.zipcode rescue self.organization.zipcode),
      country: "United States"
    }
  end
  
  def cancel
    if self.cancel_subscription
      if self.update_attributes({ active: false, end_date: Time.now })
        return true
      else
        return false
      end
    else
      return false
    end
  end
  
  protected
  
  def create_and_process_subscription
    self.start_date = Time.now + 1.day
    
    arb_sub = build_subscription_object(self)
    if self.payment_type == "cc"
      expiry = get_expiry(self.expiry_month, self.expiry_year)
      arb_sub.credit_card = AuthorizeNet::CreditCard.new(self.number, expiry, { card_code: self.ccv })
      self.payment_method = "Credit Card"
      self.payment_number = "#{self.number[(self.number.length - 4)...self.number.length]}"
    elsif self.payment_type == "bank"
      arb_sub.bank_account = AuthorizeNet::ECheck.new(self.routing_number, self.account_number, self.bank_name, (self.billing_first_name + " " + self.billing_last_name), {account_type: self.account_type})
      self.payment_method = "#{self.account_type.capitalize} Account"
      self.payment_number = "#{self.account_number[(self.account_number.to_s.length-4)...self.account_number.to_s.length]}"
    end
    arb_tran = AuthorizeNet::ARB::Transaction.new(ANET_API_LOGIN_ID, ANET_TRANSACTION_KEY, gateway: ANET_MODE)
    arb_tran.set_address(self.billing_address_for_transaction)
    # fire away!
    response = arb_tran.create(arb_sub)
    # response logging
    logger.debug("Response: \n #{response.inspect}")
    if response.success?
      self.arb_id = response.subscription_id
      self.organization.update_attribute(:active, true)
      self.active = true
      return true
    else
      return false
    end
  end
  
  def update_arb_subscription
    if self.end_date == nil && self.active?
      arb_sub = build_subscription_object_for_update(self)
      if self.payment_type == "cc"
        expiry = get_expiry(self.expiry_month, self.expiry_year)
        arb_sub.credit_card = AuthorizeNet::CreditCard.new(self.number, expiry, { card_code: self.ccv })
        self.payment_method = "Credit Card"
        self.payment_number = "#{self.number[(self.number.length - 4)...self.number.length]}"
      elsif self.payment_type == "bank"
        arb_sub.bank_account = AuthorizeNet::ECheck.new(self.routing_number, self.account_number, self.bank_name, (self.billing_first_name + " " + self.billing_last_name), {account_type: self.account_type})
        logger.debug("Account Number: #{self.account_number}")
        self.payment_method = "#{self.account_type.capitalize} Account"
        self.payment_number = "#{self.account_number[(self.account_number.to_s.length-4)...self.account_number.to_s.length]}"
      end
      arb_tran = AuthorizeNet::ARB::Transaction.new(ANET_API_LOGIN_ID, ANET_TRANSACTION_KEY, gateway: ANET_MODE)
      arb_tran.set_address(self.billing_address_for_transaction)
      logger.debug("UPdated Payment Number to #{self.payment_number}")
      # fire away!
      response = arb_tran.update(arb_sub)
      # response logging
      logger.debug("Response: \n #{response.inspect}")
      if response.success?
        return true
      else
        return false
      end
      return true
    end
  end
  
  def cancel_subscription
    logger.debug("THIS IS WHERE DESTROY GOES")
    arb_tran = AuthorizeNet::ARB::Transaction.new(ANET_API_LOGIN_ID, ANET_TRANSACTION_KEY, :gateway => ANET_MODE)
    logger.debug("This is the ARB Id: #{self.arb_id}")
    response = arb_tran.cancel(self.arb_id)
    if response.success?
      return true
    end
    return false
  end
end
