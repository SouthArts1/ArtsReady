class RenewalReceiptTemplateView < Mustache
  include ActionView::Helpers::NumberHelper

  attr_accessor :payment

  def initialize(body, payment)
    self.template = body
    self.payment = payment
  end

  def self.new_for_preview(body)
    new(body, payment_for_preview)
  end

  def amount
    number_to_currency(payment.amount)
  end

  def self.payment_for_preview
    Payment.new(
      amount: 225
    )
  end
end