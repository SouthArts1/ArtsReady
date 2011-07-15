class Need < ActiveRecord::Base
  belongs_to :crisis
  belongs_to :user
  belongs_to :organization
end
