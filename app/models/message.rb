class Message < ActiveRecord::Base
  
  belongs_to :organization
  belongs_to :user
  
  validates_presence_of :content
  validates_presence_of :visibility

  scope :for_public, -> { where(:visibility => 'public').order('created_at DESC') }
  scope :from_buddy, lambda {|buddy_list| where("visibility = 'buddies' AND organization_id IN (?)",buddy_list).order('created_at DESC').limit(30) }
  
  delegate :name, :to => :user, :allow_nil => true, :prefix => true
  delegate :name, :to => :organization, :allow_nil => true, :prefix => true
  
  def self.for_organization(org)
    (for_public + from_buddy(org.battle_buddy_list)).sort_by(&:created_at).reverse
  end

end
