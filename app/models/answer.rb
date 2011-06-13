class Answer < ActiveRecord::Base
  belongs_to :assessment
  belongs_to :question
  
  delegate :description, :to => :question, :allow_nil => true, :prefix => true
  
end
