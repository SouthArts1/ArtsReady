class BattleBuddyRequest < ActiveRecord::Base
  
  belongs_to :organization
  belongs_to :battle_buddy, :class_name => 'Organization'

  scope :pending, where('accepted IS NULL')
  
end
