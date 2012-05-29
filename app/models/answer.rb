class Answer < ActiveRecord::Base

  PREPAREDNESS = ['unknown', 'not ready', 'needs work', 'ready']
  PRIORITY = %w{critical non-critical}
  belongs_to :assessment, :counter_cache => true
  belongs_to :question
  belongs_to :organization
  has_many :todos, :dependent => :destroy
  has_many :action_items, :through => :question

  delegate :description, :help_html,
    :to => :question, :allow_nil => true, :prefix => true
  delegate :critical_function, :to => :question
  delegate :percentage_complete, :to => :assessment, :prefix => true

  validates_presence_of :assessment
  validates_presence_of :question
  validates_presence_of :preparedness, :on => :update, :unless => :was_skipped_changed?
  validates_presence_of :priority, :on => :update, :unless => :was_skipped_changed?

  attr_accessible :preparedness, :priority, :was_skipped
  attr_accessible :question # for use when creating the assessment

  after_update :add_todo_items, :if => :answered?
  after_update :update_answered_count

  scope :for_critical_function, proc {|critical_function| 
    includes(:question).
    where(['questions.critical_function = ?', critical_function])
  }

  def section_progress
    assessment.section_progress_for(critical_function)
  end

  def ready?
    preparedness=='ready'
  end

  def answered?
    preparedness.present? && priority.present?
  end
  alias_method :answered, :answered?

  scope :answered,
    :conditions => 'priority IS NOT NULL AND preparedness IS NOT NULL'
  scope :not_skipped, :conditions => 'was_skipped IS NOT TRUE'
  scope :skipped, :conditions => 'was_skipped'

  def add_todo_items
    question.action_items.active.each do |i|
      todos.create(:action_item => i, :organization => assessment.organization, :description => i.description, :critical_function => question.critical_function, :priority => priority)
      logger.debug("Added To-Do for question #{question}")
    end
  end

  def update_answered_count
    assessment.increment_completed_answers_count if answered?
  end

  def critical_function_title
    Assessment.critical_function_title(critical_function)
  end

  def as_json(options = nil)
    options ||= {}

    # TODO: hide irrelevant attributes
    super(options.merge(:methods => [
      :answered,
      :question_help_html,
      :question_description,
      :section_progress,
      :assessment_percentage_complete
    ]))
  end
end

