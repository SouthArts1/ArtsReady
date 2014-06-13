class ProvisionalSubscription < Subscription
  validates_presence_of :organization

  before_validation :initialize_defaults, on: :create
  before_create :add_created_subscription_event

  def provisional
    true
  end
  alias_method :provisional?, :provisional

  private

  def initialize_defaults
    user = organization.users.first

    self.attributes = {
      start_date: Time.zone.now,
      active: true,

      starting_amount_in_cents: PaymentVariable.float_value('starting_amount_in_cents'),
      regular_amount_in_cents: PaymentVariable.float_value('regular_amount_in_cents'),

      billing_first_name: user.first_name, billing_last_name: user.last_name,
      billing_address: organization.address, billing_city: organization.city,
      billing_state: organization.state, billing_zipcode: organization.zipcode,
      billing_phone_number: organization.phone_number,
      billing_email: 'admin@artsready.org',
    }
  end

  def set_next_billing_date
    organization.update_attributes(next_billing_date: start_date.to_date + 365)
  end

  def add_created_subscription_event
    organization.subscription_events.create(
      happened_at: Time.zone.now,
      notes: "Granted provisional access."
    )
  end
end