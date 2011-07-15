class Crisis < ActiveRecord::Base
  belongs_to :organization
  has_many :updates
  has_many :needs

  accepts_nested_attributes_for :updates
  accepts_nested_attributes_for :needs

  def resolve_crisis!
    self.resolved_on= Time.now
    self.save
  end
end
