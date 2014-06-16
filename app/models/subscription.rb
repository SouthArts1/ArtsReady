class Subscription < ActiveRecord::Base
  belongs_to :organization
  belongs_to :discount_code
  has_many :payments

  after_create :set_next_billing_date
  after_save :activate_organization, if: :active?
  after_save :cancel_previous_subscription, if: :active?

  delegate :next_billing_date, :days_left_until_rebill, to: :organization
  delegate :name, to: :organization, prefix: true

  scope :active, -> { where(active: true) }

  scope :credit_card_expiring_this_month, -> {
    where(type: 'AuthorizeNetSubscription').
      merge(AuthorizeNetSubscription.credit_card_expiring_this_month)
  }

  accepts_nested_attributes_for :organization

  def provisional # TODO: do we need the non-question-mark version?
    false
  end
  alias_method :provisional?, :provisional

  def automatic?
    false
  end

  def expired?
    next_billing_date && (next_billing_date <= Time.zone.today)
  end

  def regular_amount
    regular_amount_in_cents.to_f / 100
  end

  def regular_amount=(amount_in_dollars)
    self.regular_amount_in_cents = amount_in_dollars.to_f * 100
  end

  def cancel(metadata = nil)
    if update_attributes({ active: false, end_date: Time.now })
      if metadata
        organization.create_subscription_event(
          notes: "Cancelled by #{metadata[:role]} (#{metadata[:canceler].email})"
        )
      end

      true
    end
  end

  private

  def cancel_previous_subscription
    organization.cancel_subscriptions(except: self)
  end

  def activate_organization
    organization.update_attributes(active: true)
  end
end
