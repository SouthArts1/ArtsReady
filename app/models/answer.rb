class Answer < ActiveRecord::Base

  belongs_to :assessment
  belongs_to :question
  has_many :todos
  
  delegate :description, :to => :question, :allow_nil => true, :prefix => true
  
  after_save :add_todo_items
  
  
  def add_todo_items
    self.question.action_items.each do |i|
      self.todos.create(:action_item => i)
      logger.debug("Adding todo #{i.description} for question #{self.question.description}")
    end
  end
  
end
