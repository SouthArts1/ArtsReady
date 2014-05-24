class Subscription < ActiveRecord::Base
  belongs_to :organization
  belongs_to :discount_code
  has_many :payments

  after_create :set_next_billing_date
  after_save :activate_organization, if: :active?

  delegate :next_billing_date, :days_left_until_rebill, to: :organization
  delegate :name, to: :organization, prefix: true

  scope :active, -> { where(active: true) }

  scope :credit_card_expiring_this_month, -> {
    where(type: 'AuthorizeNetSubscription').
      merge(AuthorizeNetSubscription.credit_card_expiring_this_month)
  }

  def provisional # TODO: do we need the non-question-mark version?
    false
  end
  alias_method :provisional?, :provisional

  def automatic?
    false
  end

  def cancel
    update_attributes({ active: false, end_date: Time.now })
  end

  private

  def activate_organization
    organization.update_attributes(active: true)
  end
end
