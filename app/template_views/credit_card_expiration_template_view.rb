class CreditCardExpirationTemplateView < Mustache
  attr_accessor :organization

  def initialize(body, organization)
    self.template = body
    self.organization = organization
  end

  def self.new_for_preview(body)
    new(body, organization_for_preview)
  end

  def self.organization_for_preview
    Organization.new
  end
end