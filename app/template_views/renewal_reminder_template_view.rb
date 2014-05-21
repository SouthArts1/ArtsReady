class RenewalReminderTemplateView < TemplateView
  alias_method :organization, :model

  delegate :days_left_until_rebill, to: :organization

  def next_billing_date
    organization.next_billing_date.to_s(:long)
  end

  def organization_name
    organization.name
  end

  def self.model_for_preview
    Organization.new(
      next_billing_date: Time.zone.today + 30,
      name: 'Name of Organization'
    )
  end
end