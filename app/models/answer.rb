class Answer < ActiveRecord::Base

  PREPAREDNESS = %w{unknown not_ready needs_work ready}
  PRIORITY = %w{critical non-critical}
  belongs_to :assessment, :counter_cache => true
  belongs_to :question
  belongs_to :organization
  has_many :todos
  has_many :action_items, :through => :question

  delegate :description, :to => :question, :allow_nil => true, :prefix => true

  validates_presence_of :assessment
  validates_presence_of :question
  validates_presence_of :preparedness, :on => :update
  validates_presence_of :priority, :on => :update


  after_update :add_todo_items#, :unless => "was_skipped == true"
  after_update :answered_count
  
  scope :for_critical_function, proc {|critical_function| where(:critical_function => critical_function) }

  def ready?
    preparedness=='ready'
  end
  
  def answered?
    preparedness.present? && priority.present?
  end

  def add_todo_items
    question.action_items.each do |i|
      todos.create(:action_item => i, :organization => assessment.organization, :description => i.description) unless ready?
      logger.debug("Adding todo #{i.description} for question #{question.description}") unless ready?
    end
  end
  
  def answered_count
    Assessment.increment_counter(:completed_answers_count,assessment.id) if answered?
  end

end