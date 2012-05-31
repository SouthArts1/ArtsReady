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

  after_update :add_todo_items#, :unless => "was_skipped == true"
  after_update :notify_assessment
  
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

  def notify_assessment
    assessment.answer_was_answered if answered?
    assessment.answer_was_skipped if (was_skipped? && was_skipped_changed?)
  end

  def critical_function_title
    Assessment.critical_function_title(critical_function)
  end
end
