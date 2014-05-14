class CreditCardExpirationTemplateView < TemplateView
  alias_method :organization, :model

  def self.model_for_preview
    Organization.new
  end
end