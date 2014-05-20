class CreditCardExpirationTemplateView < TemplateView
  alias_method :organization, :model

  def self.model_for_preview
    Organization.new
  end

  def next_billing_date
    organization.next_billing_date.to_s(:long)
  end
end