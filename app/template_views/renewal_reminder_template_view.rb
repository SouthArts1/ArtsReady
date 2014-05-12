class RenewalReminderTemplateView < Mustache
  attr_accessor :organization

  def initialize(body, organization)
    self.template = body
    self.organization = organization
  end

  def self.new_for_preview(body)
    new(body, organization_for_preview)
  end

  def next_billing_date
    organization.next_billing_date.to_s(:long)
  end

  def self.organization_for_preview
    Organization.new(next_billing_date: Time.zone.today + 30)
  end
end