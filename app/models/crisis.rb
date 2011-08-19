class Crisis < ActiveRecord::Base

  belongs_to :organization
  has_many :needs
  has_many :updates

  accepts_nested_attributes_for :updates
  accepts_nested_attributes_for :needs

  scope :active, includes(:organization).where(:resolved_on => nil)
  scope :public, where(:visibility => 'public')
  scope :private, where(:visibility => 'private')
  
  def resolve_crisis!
    self.resolved_on= Time.now
    self.save
  end

end