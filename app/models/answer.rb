class Answer < ActiveRecord::Base

  belongs_to :assessment
  belongs_to :question
  
  delegate :description, :to => :question, :allow_nil => true, :prefix => true
  
  after_save :add_todo_items
  
  
  def add_todo_items
    self.question.action_items.each do |i|
      logger.debug("Adding action item #{i.description}")
    end
  end
  
end
