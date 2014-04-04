class Payment < ActiveRecord::Base
  self.table_name = 'charges'

  belongs_to :organization
  belongs_to :subscription
  belongs_to :discount_code

  METHODS = ['Credit Card', 'Bank Account']
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

  validates_presence_of :organization, :subscription
  validates_inclusion_of :payment_method, in: METHODS

  def amount
    amount_in_cents.try(:/, 100)
  end

  def amount=(dollars)
    self.amount_in_cents = dollars.try(:*, 100)
  end
end