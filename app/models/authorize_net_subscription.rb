class AuthorizeNetSubscription < Subscription
  attr_accessor :skip_callbacks
  attr_accessor :amount, :number, :ccv,
    :bank_name, :account_type, :routing_number, :account_number,
    :payment_type
  attr_accessor :failed_transaction_response

  before_validation :initialize_start_date, on: :create
  before_create :create_and_charge_arb_subscription
  before_update :update_arb_subscription, :unless => :skip_callbacks

  validates_presence_of :billing_first_name, :billing_last_name,
    :billing_address, :billing_city, :billing_state, :billing_zipcode,
    :billing_email
  validates_inclusion_of :payment_type, in: %w(cc bank),
    message: 'must be Credit Card or Bank Account',
    allow_nil: true # for updates that don't include payment info
  validates_presence_of :number, :expiry_month, :expiry_year, :ccv,
    if: :submitted_as_cc?
  validates_presence_of :routing_number, :account_number, :bank_name,
    :account_type,
    if: :submitted_as_bank?
  validates_length_of :number, in: 13..16, allow_nil: true
  validate :credit_card_must_not_have_expired_by_billing_date

  scope :credit_card_expiring_this_month, -> {
    date = Time.zone.today
    where(expiry_month: date.month, expiry_year: date.year)
  }

  def copy_billing_info_from(source)
    [
      :billing_first_name, :billing_last_name,
      :billing_address, :billing_city, :billing_state, :billing_zipcode,
      :billing_phone_number, :billing_email
    ].each do |attr|
      self[attr] = source[attr]
    end
  end

  def automatic?
    true
  end

  def submitted_as_cc? # via billing form
    payment_type == 'cc'
  end

  def submitted_as_bank? # via billing form
    payment_type == 'bank'
  end

  def number=(number)
    number.gsub!(/\s+/, '') if number

    @number = number
  end

  def initialize_start_date
    self.start_date ||= Time.now + 1.day
  end

  def billing_date_after(date)
    start = start_date.to_date

    if date < start
      start
    else
      distance_in_years = (date - start) / 365
      start + (distance_in_years.floor + 1) * 365
    end
  end

  def validate_discount_code!
    start_amount = PaymentVariable.float_value("starting_amount_in_cents")
    regular_amount = PaymentVariable.float_value("regular_amount_in_cents")

    d = self.discount_code
    if d && d.is_valid?
      start_amount = d.starting_deduction.apply_to(start_amount) if d.apply_to_first_year?
      regular_amount = d.recurring_deduction.apply_to(regular_amount) if d.apply_to_post_first_year?
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

  def cancel(metadata = nil)
    skipping_callbacks do
      if cancel_arb_subscription
        return super(metadata)
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
      start_date: next_billing_date.beginning_of_day,
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

  # These are a little different from ordinary validations because the
  # user has no control over them. If one of these fails, it's because
  # we've made a mistake in the code.
  def validate_for_creation
    return false if id
    return false if !organization
    return false if !regular_amount_in_cents || !starting_amount_in_cents

    return true
  end

  def create_and_charge_arb_subscription
    return false if !validate_for_creation

    arb_sub = build_arb_subscription_for_create()

    set_payment_info(arb_sub)

    # ARB doesn't support free subscriptions, so we bypass it in that case
    return false unless free_after_first_year? || create_arb_transaction(arb_sub)

    self.active = true
  end

  def create_arb_transaction(arb_sub)
    arb_tran = build_transaction(AuthorizeNet::ARB::Transaction, true)
    Rails.logger.debug("ARB TRAN: #{arb_tran.inspect}")

    response = arb_tran.create(arb_sub)

    if !response.success?
      self.failed_transaction_response = response
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
    replacing = payment_type_changed? || !active?

    arb_sub = replacing ?
      build_arb_subscription_for_replace :
      build_arb_subscription_for_update

    set_payment_info(arb_sub)

    return false unless update_or_replace_arb_subscription(arb_sub, replacing)
  end

  def set_payment_info(arb_sub)
    if payment_type == "cc"
      expiry              = get_expiry(expiry_month, expiry_year)
      arb_sub.credit_card = AuthorizeNet::CreditCard.new(
        number, expiry,
        card_code: ccv
      )
      self.payment_method = "Credit Card"
      self.payment_number = number.last(4)
    elsif payment_type == "bank"
      arb_sub.bank_account = AuthorizeNet::ECheck.new(
        routing_number, account_number, bank_name,
        billing_first_name + " " + billing_last_name,
        account_type: account_type
      )
      self.payment_method  = "#{account_type.capitalize} Account"
      self.payment_number  = account_number.last(4)
    end
  end

  def update_or_replace_arb_subscription(arb_sub, replacing)
    cancel_arb_subscription if replacing

    arb_tran = build_transaction(AuthorizeNet::ARB::Transaction, true)
    Rails.logger.debug("Updating Payment Number to #{self.payment_number}")

    response = replacing ?
      arb_tran.create(arb_sub) :
      arb_tran.update(arb_sub)

    if response.success? || (replacing && (response.response.response_reason_text.include?("ACH") rescue false))
      self.arb_id = response.subscription_id if response.subscription_id
      self.active = true
      self.end_date = nil

      true
    else
      self.failed_transaction_response = response

      false
    end
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

  def credit_card_must_not_have_expired_by_billing_date
    return unless payment_type == 'cc'
    return unless expiry_month.presence && expiry_year.presence

    expiration =
      Date.new(Integer(expiry_year), Integer(expiry_month)).
        end_of_month

    if Time.zone.today > expiration
      errors[:base] << 'Credit card has expired'
    elsif billing_date_after(Time.zone.today) > expiration
      errors[:base] << 'Credit card will expire before billing date'
    end
  end

  def set_next_billing_date
    organization.update_attributes(next_billing_date: start_date.to_date)
  end
end