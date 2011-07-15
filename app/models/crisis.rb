class Crisis < ActiveRecord::Base
  belongs_to :organization
  has_many :updates
  
  accepts_nested_attributes_for :updates
  
  def resolve_crisis!
    self.resolved_on= Time.now
    self.save
  end
end
