class RenewalReceiptTemplateView < TemplateView
  include ActionView::Helpers::NumberHelper

  alias_method :payment, :model

  def amount
    number_to_currency(payment.amount)
  end

  def self.model_for_preview
    Payment.new(
      amount: 225
    )
  end
end