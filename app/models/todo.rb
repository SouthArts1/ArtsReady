class Todo < ActiveRecord::Base
  belongs_to :organization
  belongs_to :answer
  belongs_to :action_item
end
