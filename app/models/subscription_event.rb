class SubscriptionEvent < ActiveRecord::Base
  belongs_to :organization
  has_one :payment

  attr_accessible :organization_id, :happened_at, :notes
  accepts_nested_attributes_for :payment

  validates_presence_of :happened_at

  before_validation :set_default_happened_at, on: :create

  def happened_at_date
    happened_at.try(:strftime, '%Y-%m-%d')
  end

  def happened_at_time
    happened_at.try(:strftime, '%l:%M %p').try(:strip)
  end

  def happened_at_date=(date)
    return if date.blank?

    date = Date.strptime(date, '%Y-%m-%d')

    if happened_at
      self.happened_at = Time.zone.local(
        date.year, date.month, date.day,
        happened_at.hour, happened_at.min, happened_at.sec
      )
    else
      self.happened_at = date.beginning_of_day
    end
  end

  def happened_at_time=(time)
    return if time.blank?

    time = Time.zone.parse(time)

    if happened_at
      self.happened_at = Time.zone.local(
        happened_at.year, happened_at.month, happened_at.day,
        time.hour, time.min, time.sec
      )
    else
      self.happened_at = time
    end
  end
  
  private

  def set_default_happened_at
    self.happened_at ||= Time.zone.now
  end
end
