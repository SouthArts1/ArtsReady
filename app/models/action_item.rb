class ActionItem < ActiveRecord::Base
  belongs_to :question
  has_many :todos

  validates_presence_of :question
  validates_presence_of :description

end