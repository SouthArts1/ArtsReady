class RenewalReceiptTemplateView < Mustache
  include ActionView::Helpers::NumberHelper

  attr_accessor :payment

  def initialize(body, payment)
    self.template = body
    self.payment = payment
  end

  def amount
    number_to_currency(payment.amount)
  end
end