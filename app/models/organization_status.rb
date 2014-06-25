class OrganizationStatus
  attr_accessor :organization, :subscription

  def initialize(organization, subscription)
    self.organization = organization
    self.subscription = subscription
  end

  def label
    key = [organization.active?, !!subscription, subscription.try(:active?)]

    label = {
      [false, false, nil  ] => :new,
      [false, true,  false] => :cancelled,
      [false, true,  true ] => :disabled,
      [true,  false, nil  ] => :temporarily_approved,
      [true,  true,  true ] => :active
    }.fetch(key, :unknown)

    if label == :active && subscription.past_due?
      :past_due
    else
      label
    end
  end

  def to_s
    label.to_s.gsub('_', ' ')
  end
end