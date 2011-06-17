class ActionItem < ActiveRecord::Base
  belongs_to :question
  has_many :todos
end
