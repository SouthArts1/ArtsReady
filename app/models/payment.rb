class Payment < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :subscription_event, inverse_of: :payment
  belongs_to :subscription
  belongs_to :discount_code
  has_one :notification, class_name: 'PaymentNotification'

  attr_accessor :extend_subscription
  alias_method :extend_subscription?, :extend_subscription

  delegate :organization, to: :subscription_event
  delegate :billing_emails, to: :organization

  before_save :clear_routing_number, unless: :bank_account?
  before_validation :associate_subscription, on: :create
  after_save :extend_next_billing_date, if: :extend_subscription?
  after_create :extend_next_billing_date, if: :success_from_notification?

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
  validates_presence_of :subscription_event,
    :amount, :account_type, :account_number
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

  def self.blank_attributes?(attrs)
    attrs.all? do |name, value|
      case name
        when 'extend_subscription' then value == '0'
        else value.blank?
      end
    end
  end

  private

  def associate_subscription
    self.subscription ||= organization.try(:subscription)
  end

  # if an admin requests to extend the next billing date, we should set
  # it to 365 days after the previous billing date.
  def extend_next_billing_date
    subscription_event.extend_next_billing_date!
  end

  def success_from_notification?
    notification && notification.success?
  end

  def clear_routing_number
    self.routing_number = nil
  end
end