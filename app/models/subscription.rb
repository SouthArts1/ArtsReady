class Subscription < ActiveRecord::Base
  self.table_name = 'payments'

  belongs_to :organization
  belongs_to :discount_code
  has_many :payments

  attr_accessor :skip_callbacks
  attr_accessor :amount, :number, :ccv, :bank_name, :account_type, :routing_number, :account_number, :payment_type
  
  before_create :create_and_charge_arb_subscription
  before_update :update_arb_subscription, :unless => :skip_callbacks
  
  validates_presence_of :organization_id

  def self.build_provisional(attrs = {})
    new(attrs).tap { |subscription| subscription.make_provisional }
  end

  def make_provisional
    raise ArgumentError if !organization

    user = organization.users.first

    self.attributes = {
      starting_amount_in_cents: 30000,
      regular_amount_in_cents: 22500,
      start_date: Time.now,
      active: 1,
      billing_first_name: user.first_name, billing_last_name: user.last_name,
      billing_address: organization.address, billing_city: organization.city,
      billing_state: organization.state, billing_zipcode: organization.zipcode,
      billing_phone_number: organization.phone_number,
      billing_email: 'admin@artsready.org',
      number: "4007000000027",
      expiry_month: "02", expiry_year: Date.today.year + 1,
      ccv: "123", payment_type: 'cc'
    }
  end

  # Used on billing info page. Not tested or trusted. Should be revised
  # once we more accurately track billing dates with Authorize.net.
  def days_left_until_rebill
    return 0 if !self.start_date
    return (((self.start_date) - (Time.now)).to_i / (24 * 60 * 60)) if self.start_date > Time.now
    return (((self.start_date + 365.days) - (Time.now)).to_i / (24 * 60 * 60)) rescue 0
  end

  # Used to calculate "start date" for "replaced" subscriptions (i.e., when
  # we have to tell Authorize.Net to create a "new" subscription to update
  # one that already exists but can't be modified in the way we want). Should
  # be revised once we more accurately track billing dates with Authorize.net.
  def next_billing_date
    billing_date_after(Time.zone.now)
  end

  # Utility for `next_billing_date`. Easier to test.
  def billing_date_after(time)
    if time < start_date
      start_date
    else
      distance_in_years = (time - start_date) / 1.year
      start_date + (distance_in_years.floor + 1).years
    end
  end

  def validate_discount_code!
    start_amount = PaymentVariable.find_by_key("starting_amount_in_cents").value.to_f
    regular_amount = PaymentVariable.find_by_key("regular_amount_in_cents").value.to_f

    d = self.discount_code
    if d && d.is_valid?
      if d.deduction_type == "percentage"
        start_amount = start_amount.to_f * ((100 - d.deduction_value).to_f / 100) if d.apply_to_first_year?
      elsif d.deduction_type == "dollars"
        start_amount = start_amount.to_f - (d.deduction_value * 100) if d.apply_to_first_year?
      end
      if d.recurring_deduction_type == "percentage"
        regular_amount = regular_amount.to_f * ((100 - d.recurring_deduction_value).to_f / 100) if d.apply_to_post_first_year?
      elsif d.recurring_deduction_type == "dollars"
        regular_amount = regular_amount.to_f - (d.recurring_deduction_value * 100) if d.apply_to_post_first_year?
      end
    end
    
    self.starting_amount_in_cents = start_amount
    self.regular_amount_in_cents = regular_amount
  end
  
  def get_expiry(expiry_month, expiry_year)
    expiry_month = "01" if expiry_month.to_s.length == 0
    expiry_year = Time.now.year.to_s if expiry_year.to_s.length < 4
    expiry_month = "0" + expiry_month.to_s if expiry_month.to_s.length == 1
    expiry_year = expiry_year.to_s.split("")[2] + expiry_year.to_s.split("")[3]
    return expiry_month.to_s + expiry_year.to_s
  end

  def skipping_callbacks
    was_skipping_callbacks = skip_callbacks
    self.skip_callbacks = true
    yield self
  ensure
    self.skip_callbacks = was_skipping_callbacks
  end

  def cancel
    skipping_callbacks do
      if cancel_arb_subscription
        return update_attributes({ active: false, end_date: Time.now })
      else
        return false
      end
    end
  end

  private

  # Initial ARB subscription for this account.
  def build_arb_subscription_for_create
    sub = AuthorizeNet::ARB::Subscription.new(
      name: "ArtsReady Yearly Subscription",
      length: 365, 
      unit: AuthorizeNet::ARB::Subscription::IntervalUnits::DAY,
      start_date: start_date,
      total_occurrences: 9999,
      amount: regular_amount_in_cents.to_f / 100,
      trial_amount: starting_amount_in_cents.to_f / 100,
      trial_occurrences: 1,
      description: "#{organization.name} subscription for ArtsReady",
      customer: customer_for_transaction,
      billing_address: billing_address_for_transaction
    )
    return sub
  end

  # Account has an ARB subscription, but we can't modify it, so we
  # replace it with a new one.
  def build_arb_subscription_for_replace
    sub = AuthorizeNet::ARB::Subscription.new(
      name: "ArtsReady Yearly Subscription",
      length: 365, 
      unit: AuthorizeNet::ARB::Subscription::IntervalUnits::DAY,
      start_date: next_billing_date,
      total_occurrences: 9999,
      amount: regular_amount_in_cents.to_f / 100,
      description: "#{organization.name} subscription for ArtsReady",
      customer: customer_for_transaction,
      billing_address: billing_address_for_transaction
    )
    return sub
  end

  # Account has an ARB subscription and we want to modify it.
  def build_arb_subscription_for_update
    sub = AuthorizeNet::ARB::Subscription.new(
      subscription_id: arb_id,
      amount: regular_amount_in_cents.to_f / 100,
      trial_amount: starting_amount_in_cents.to_f / 100,
      customer: customer_for_transaction,
      billing_address: billing_address_for_transaction
    )
    return sub
  end

  def customer_for_transaction
    {
      email: (billing_email.presence || organization.email),
      phone_number: billing_phone_number || organization.phone_number
    }
  end

  def billing_address_for_transaction
    return {
      first_name: (billing_first_name rescue ""),
      last_name: (billing_last_name rescue ""),
      company: (organization.name.truncate(23) rescue ""),
      address: (billing_address rescue organization.address),
      city: (billing_city rescue organization.city),
      state: (billing_state rescue organization.state),
      zip: (billing_zipcode rescue organization.zipcode),
      country: "United States"
    }
  end

  # These would be validations in any ordinary Rails object, but
  # I guess the Rails developer who wrote them wasn't familiar with
  # the concept. Anyway, I'm leaving them as non-validations in case
  # there was some reason.
  def validate_for_creation
    return false if self.id
    return false if !Organization.exists?(self.organization_id)
    return false if self.regular_amount_in_cents.nil? || self.starting_amount_in_cents.nil?
    return false if self.billing_first_name.nil? || self.billing_last_name.nil? || self.billing_address.nil? || self.billing_city.nil? || self.billing_state.nil? || self.billing_zipcode.nil? || billing_email.blank?
    if self.payment_type == "cc"
      return false if self.number.nil? || self.expiry_month.nil? || self.expiry_year.nil? || self.ccv.nil?
    elsif self.payment_type == "bank"
      return false if self.routing_number.nil? || self.account_number.nil? || self.bank_name.nil? || self.account_type.nil?
    else
      return false
    end
    
    return true
  end
  
  def create_and_charge_arb_subscription
    return false if !validate_for_creation

    self.start_date = Time.now + 1.day unless self.start_date
    
    arb_sub = build_arb_subscription_for_create()
    if self.payment_type == "cc"
      expiry = get_expiry(self.expiry_month, self.expiry_year)
      arb_sub.credit_card = AuthorizeNet::CreditCard.new(self.number, expiry, { card_code: self.ccv })
      Rails.logger.debug("ARB: #{arb_sub.credit_card.inspect}")
      self.payment_method = "Credit Card"
      self.number = self.number.to_s
      self.payment_number = "#{self.number[(self.number.length - 4)...self.number.length]}"
    elsif self.payment_type == "bank"
      arb_sub.bank_account = AuthorizeNet::ECheck.new(self.routing_number, self.account_number, self.bank_name, (self.billing_first_name + " " + self.billing_last_name), {account_type: self.account_type})
      self.payment_method = "#{self.account_type.capitalize} Account"
      self.payment_number = "#{self.account_number[(self.account_number.to_s.length-4)...self.account_number.to_s.length]}"
    end
    
    # Payment Authorization
    aim_tran = build_transaction(AuthorizeNet::AIM::Transaction, true)
    
    if self.payment_method == "Credit Card"
      Rails.logger.debug("AIM TRAN: #{aim_tran.inspect}")
      aim_response = aim_tran.authorize((self.starting_amount_in_cents.to_f / 100), arb_sub.credit_card)
      Rails.logger.debug("AIM TRAN RESPONSE: #{aim_response.inspect}")
    elsif self.payment_type == "bank"
      aim_response = aim_tran.authorize((self.starting_amount_in_cents.to_f / 100), arb_sub.bank_account)
    else
      return false
    end
    
    return false unless aim_response.success? || (self.payment_type == "cc" && self.number == "4007000000027")
    # ARB doesn't support free subscriptions, so we bypass it in that case
    return false unless free_after_first_year? || create_arb_transaction(arb_sub)

    organization.update_attribute(:active, true)
    self.active = true
  end
  
  def create_arb_transaction(arb_sub)
    arb_tran = build_transaction(AuthorizeNet::ARB::Transaction, true)
    Rails.logger.debug("ARB TRAN: #{arb_tran.inspect}")

    response = arb_tran.create(arb_sub)

    if !response.success?
      Airbrake.notify_or_ignore(nil,
        error_message: 'ARB response',
        parameters: {
          response: response.inspect.gsub(/([0-9]{2})[0-9]{10}[0-9]*/, '0x\1L0NGNUMB3R'),
          response_response: (response.response rescue nil).inspect
        }
      )
    end

    success = response.success? || (response.response.response_reason_text.include?("ACH") rescue false)
    self.arb_id = response.subscription_id if success
    success
  end

  def free_after_first_year?
    regular_amount_in_cents == 0
  end

  def payment_type_changed?
    Rails.logger.debug("Old payment type: #{Subscription.find(self.id).payment_method} and new type: #{self.payment_type}")
    if Subscription.find(self.id).payment_method == "Credit Card" && self.payment_type == "bank"
      return true
    elsif Subscription.find(self.id).payment_method.downcase.include?("account") && self.payment_type == "cc"
      return true
    else
      return false
    end
  end
  
  def update_arb_subscription
      if !payment_type_changed? && self.active?
        arb_sub = build_arb_subscription_for_update
        if self.payment_type == "cc"
          expiry = get_expiry(self.expiry_month, self.expiry_year)
          arb_sub.credit_card = AuthorizeNet::CreditCard.new(self.number, expiry, { card_code: self.ccv })
          self.payment_method = "Credit Card"
          self.payment_number = "#{self.number[(self.number.length - 4)...self.number.length]}"
        elsif self.payment_type == "bank"
          arb_sub.bank_account = AuthorizeNet::ECheck.new(self.routing_number, self.account_number, self.bank_name, (self.billing_first_name + " " + self.billing_last_name), {account_type: self.account_type})
          Rails.logger.debug("Account Number: #{self.account_number}")
          self.payment_method = "#{self.account_type.capitalize} Account"
          self.payment_number = "#{self.account_number[(self.account_number.to_s.length-4)...self.account_number.to_s.length]}"
        end
      
        # Payment Authorization
        aim_tran = build_transaction(AuthorizeNet::AIM::Transaction)
        if self.payment_method == "Credit Card"
          aim_response = aim_tran.authorize((self.regular_amount_in_cents.to_f / 100), arb_sub.credit_card)
        elsif self.payment_type == "bank"
          aim_response = aim_tran.authorize((self.regular_amount_in_cents.to_f / 100), arb_sub.bank_account)
        else
          return false
        end
      
        if aim_response.success?
          arb_tran = build_transaction(AuthorizeNet::ARB::Transaction, true)
          Rails.logger.debug("UPdated Payment Number to #{self.payment_number}")
          # fire away!
          response = arb_tran.update(arb_sub)
          # response logging
          Rails.logger.debug("Response: \n #{response.inspect}")
          if response.success?
            self.active = true
            self.end_date = nil
            return true
          else
            return false
          end
          return true
        else
          return false
        end
      else
        cancel_arb_subscription
        arb_sub = build_arb_subscription_for_replace
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

        # Payment Authorization
        aim_tran = build_transaction(AuthorizeNet::AIM::Transaction, true)

        if self.payment_method == "Credit Card"
          aim_response = aim_tran.authorize((self.starting_amount_in_cents.to_f / 100), arb_sub.credit_card)
        elsif self.payment_type == "bank"
          aim_response = aim_tran.authorize((self.starting_amount_in_cents.to_f / 100), arb_sub.bank_account)
        else
          return false
        end

        if aim_response.success? || (self.payment_type == "cc" && self.number == "4007000000027")
          arb_tran = build_transaction(AuthorizeNet::ARB::Transaction, true)

          response = arb_tran.create(arb_sub)

          if response.success? || (response.response.response_reason_text.include?("ACH") rescue false)
            self.arb_id = response.subscription_id
            self.organization.update_attribute(:active, true)
            Rails.logger.debug("Reset Active and End Date")
            self.active = true
            self.end_date = nil
            return true
          else
            return false
          end
        else
          return false
        end
      end
      return true
  end
  
  def cancel_arb_subscription
    status_arb_tran = build_transaction(AuthorizeNet::ARB::Transaction)
    status_response = status_arb_tran.get_status(self.arb_id)
    if status_response.success?
      arb_tran = build_transaction(AuthorizeNet::ARB::Transaction)
      response = arb_tran.cancel(self.arb_id)
      Rails.logger.debug("Response: #{response.inspect}")
      Rails.logger.debug("Message: #{response.message_text}")
      if response.success? || (response.message_text.include?("canceled") rescue false)
        Rails.logger.debug("Passes validation.  It is or has been cancelled")
        return true
      else
        return false
      end
    else
      if status_response.message_text.include?("cannot be found")
        Rails.logger.debug("It does not exist, cancelling correctly")
        return true
      else
        return false
      end
    end
  end

  def build_transaction(klass, include_subscription_info = false)
    klass.new(ANET_API_LOGIN_ID, ANET_TRANSACTION_KEY, gateway: ANET_MODE).tap do |transaction|
      if ANET_ALLOW_DUPLICATE_TRANSACTIONS
        transaction.set_fields(:duplicate_window => 0)
      end

      if include_subscription_info
        transaction.set_address(billing_address_for_transaction)
        transaction.set_customer(email: billing_email.presence || organization.email)
      end
    end
  end
end
