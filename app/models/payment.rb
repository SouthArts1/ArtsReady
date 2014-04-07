class Payment < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  self.table_name = 'charges'

  belongs_to :organization
  belongs_to :subscription
  belongs_to :discount_code

  before_validation :set_default_paid_at, on: :create
  before_validation :associate_subscription, on: :create

  CREDIT_ACCOUNT_TYPES = [
    'Visa', 'MasterCard', 'AmericanExpress',
    'Discover', 'JCB', 'DinersClub'
  ]
  BANK_ACCOUNT_TYPES = [
    'Checking',
    'Savings'
  ]
  ACCOUNT_TYPES = [
    ['Credit Card', CREDIT_ACCOUNT_TYPES],
    ['Bank Account', BANK_ACCOUNT_TYPES],
  ]

  validates_presence_of :organization,
    :amount, :account_type, :account_number, :paid_at
  validates_presence_of :routing_number, if: :bank_account?
  validates_numericality_of :amount, :arb_id,
    :account_number, :routing_number,
    allow_blank: true

  def amount
    amount_in_cents.try(:/, 100)
  end

  def amount=(dollars)
    self.amount_in_cents = dollars.try(:to_i).try(:*, 100)
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

  private

  def set_default_paid_at
    self.paid_at ||= Time.zone.now
  end

  def associate_subscription
    self.subscription = organization.try(:subscription)
  end
end