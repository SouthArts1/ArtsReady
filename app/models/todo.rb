class Todo < ActiveRecord::Base
  belongs_to :answer
  belongs_to :action_item
end
