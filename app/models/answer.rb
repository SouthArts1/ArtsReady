class Answer < ActiveRecord::Base

  PREPAREDNESS = ['unknown', 'not ready', 'needs work', 'ready']
  PRIORITY = %w{critical non-critical}
  belongs_to :assessment, :counter_cache => true
  belongs_to :question
  belongs_to :organization
  has_many :todos, :dependent => :destroy
  has_many :action_items, :through => :question

  delegate :description, :to => :question, :allow_nil => true, :prefix => true
  delegate :critical_function, :to => :question

  validates_presence_of :assessment
  validates_presence_of :question
  validates_presence_of :preparedness, :on => :update, :unless => :was_skipped?
  validates_presence_of :priority, :on => :update, :unless => :was_skipped?

  before_update :check_assessment_complete
  after_update :add_todo_items#, :unless => "was_skipped == true"
  after_update :answered_count

  scope :pending, where(
    '(NOT was_skipped OR was_skipped IS NULL) AND
    preparedness IS NULL AND
    priority IS NULL'
  )
  
  scope :for_critical_function, proc {|critical_function| 
    includes(:question).
    where(['questions.critical_function = ?', critical_function])
  }

  def ready?
    preparedness=='ready'
  end

  def answered?
    preparedness.present? && priority.present?
  end

  def add_todo_items
    question.action_items.active.each do |i|
      todos.create(:action_item => i, :organization => assessment.organization, :description => i.description, :critical_function => question.critical_function, :priority => priority)
      logger.debug("Added To-Do for question #{question}")
    end
  end

  def answered_count
    Assessment.increment_counter(:completed_answers_count,assessment.id) if answered?
  end

  def critical_function_title
    Assessment.critical_function_title(critical_function)
  end
  
  def check_assessment_complete
    if (was_skipped? && was_skipped_changed?) ||
      (preparedness.present? && priority.present? &&
      (preparedness_changed? && priority_changed?))
      assessment.check_complete
    end
  end
end
