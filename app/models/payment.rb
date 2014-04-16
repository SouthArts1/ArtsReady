class Payment < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  self.table_name = 'charges'

  belongs_to :organization
  belongs_to :subscription
  belongs_to :discount_code

  before_validation :set_default_paid_at, on: :create
  before_validation :associate_subscription, on: :create
  before_save :clear_routing_number, unless: :bank_account?

  CREDIT_ACCOUNT_TYPES = [
    'Visa', 'MasterCard', 'American Express',
    'Discover', 'JCB', 'Diners Club'
  ]
  BANK_ACCOUNT_TYPES = [
    'Checking',
    'Savings'
  ]
  ACCOUNT_TYPES = [
    ['Credit Card', CREDIT_ACCOUNT_TYPES],
    ['Bank Account', BANK_ACCOUNT_TYPES],
  ]

  # NOTE: We don't validate account type, because if Authorize.Net
  # sends us an unknown account type, we want to record it instead
  # of discarding it.
  validates_presence_of :organization,
    :amount, :account_type, :account_number, :paid_at
  validates_presence_of :routing_number, if: :bank_account?
  validates_numericality_of :amount, :transaction_id,
    :account_number, :routing_number,
    allow_blank: true

  def amount
    amount_in_cents.try(:/, 100.0)
  end

  def amount=(dollars)
    dollars.sub!(/^\s*\$/, '') if dollars.respond_to? :sub!

    self.amount_in_cents = dollars.try(:to_f).try(:*, 100)
  end

  def bank_account?
    ACCOUNT_TYPES.assoc('Bank Account').last.include? account_type
  end

  def credit_card?
    ACCOUNT_TYPES.assoc('Credit Card').last.include? account_type
  end

  def account_number=(value)
    super value.try(:last, 4)
  end

  def routing_number=(value)
    super value.try(:last, 4)
  end

  def paid_at_date
    paid_at.try(:strftime, '%Y-%m-%d')
  end

  def paid_at_time
    paid_at.try(:strftime, '%l:%M %p').try(:strip)
  end

  def paid_at_date=(date)
    return if date.blank?

    date = Date.strptime(date, '%Y-%m-%d')

    if paid_at
      self.paid_at = Time.zone.local(
        date.year, date.month, date.day,
        paid_at.hour, paid_at.min, paid_at.sec
      )
    else
      self.paid_at = date.beginning_of_day
    end
  end

  def paid_at_time=(time)
    return if time.blank?

    time = Time.zone.parse(time)

    if paid_at
      self.paid_at = Time.zone.local(
        paid_at.year, paid_at.month, paid_at.day,
        time.hour, time.min, time.sec
      )
    else
      self.paid_at = time
    end
  end

  private

  def set_default_paid_at
    self.paid_at ||= Time.zone.now
  end

  def associate_subscription
    self.subscription ||= organization.try(:subscription)
    self.organization ||= subscription.try(:organization)
  end

  def clear_routing_number
    self.routing_number = nil
  end
end