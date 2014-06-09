class BillingFormTestPage < TestPage
  def self.default_billing_address
    'billing@example.com'
  end

  def fill_out(overrides = {})
    fields = {
      'Billing first name' => 'Bill',
      'Billing last name' => 'Lastname',
      'Billing address' => '100 Test St',
      'Billing city' => 'New York',
      'Billing state' => 'NY',
      'Billing zip code' => '10001',
      'Billing email' => self.class.default_billing_address,
      'Billing phone number' => '555-555-1212',
      'Please choose your payment type:' => 'Credit Card',
      'subscription_number' => '5555 5555 5555 4444',
      'subscription_expiry_month' => '1',
      'subscription_expiry_year' => (Time.now.year + 3).to_s,
      'subscription_ccv' => '888'
    }.merge(overrides)

    world.fill_in_fields(fields)

    self
  end

  def enter_payment(method)
    world.fill_in_fields(method.fields)

    self
  end

  def submit
    world.press 'Submit Payment'

    self
  end

  def self.payment_method(name, overrides = {})
    payment_method_class(name).new(overrides)
  end

  def self.payment_method_class(name)
    {
      'checking account' => CheckingAccountPaymentMethod,
      'savings account'  => SavingsAccountPaymentMethod,
      'credit card'      => CreditCardPaymentMethod
    }.fetch(name)
  end

  class PaymentMethod
    attr_accessor :overrides

    def initialize(overrides)
      self.overrides = overrides
    end

    def fields
      default_fields.merge(overrides)
    end
  end

  class CreditCardPaymentMethod < PaymentMethod
    def default_fields
      {
        'subscription_payment_type' => 'Credit Card',
        'subscription_number'       => '5555 5555 5555 4444',
        'subscription_expiry_month' => '1',
        'subscription_expiry_year'  => (Time.now.year + 3).to_s,
        'subscription_ccv'          => '888'
      }
    end
  end

  class BankAccountPaymentMethod < PaymentMethod
    def default_fields
      {
        'subscription_payment_type'   => 'Bank Account',
        'subscription_bank_name'      => 'First Bank of Nowheresville',
        'subscription_account_type'   => account_type,
        'subscription_routing_number' => '061092387',
        'subscription_account_number' => '123456789'
      }
    end
  end

  class CheckingAccountPaymentMethod < BankAccountPaymentMethod
    def account_type
      'Checking'
    end
  end

  class SavingsAccountPaymentMethod < BankAccountPaymentMethod
    def account_type
      'Savings'
    end
  end
end
