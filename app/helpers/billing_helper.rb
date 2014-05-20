module BillingHelper
  # Hide sensitive payment information.
  #
  # Returns the value, unless the key is a value we want to keep
  # secure, in which case we return a string of Xs.
  def safe_payment_input_value(value, key)
    if [:card_num, :card_code, :bank_acct_num].include? key
      'X' * value.length
    else
      value
    end
  end
end
