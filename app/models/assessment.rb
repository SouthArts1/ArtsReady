class Assessment < ActiveRecord::Base

  belongs_to :organization
  has_many :users, :through => :organization
  has_many :answers, :dependent => :destroy
  has_many :todos, :through => :answers
  has_one :reassessment_todo, :through => :organization, :source => :todos, 
    :conditions => {:key => 'reassessment'}
  # TODO: make this work for multiple years.

  attr_accessor :critical_functions

  validates_presence_of :organization

  after_create :populate_empty_answers

  scope :complete, where('completed_at IS NOT NULL')

  scope :pending_reassessment_todo, lambda {
    where(['completed_at < ?', 11.months.ago]).
      joins(:organization).
      joins("LEFT OUTER JOIN todos
        ON todos.organization_id = organizations.id
       AND todos.key = 'reassessment'").
      where('todos.organization_id IS NULL OR todos.complete')
  }

  # internal method checks whether all questions are skipped or answered
  private
  def completed?
    return false unless answers_count > 0
    (completed_answers_count + skipped_answers_count) == answers_count
  end
  public

  # public method: true if the assessment has already been declared complete
  def complete?
    completed_at
  end

  def answer_was_answered
    update_attribute(:completed_answers_count, completed_answers_count + 1)
    check_complete
  end

  def answer_was_skipped
    check_complete
  end
  
  def check_complete
    if !completed_at && completed?
      update_attribute :completed_at, Time.zone.now
    end
  end
  
  def create_reassessment_todo
    attrs = {
      :critical_function => 'people', :user => users.first,
      :priority => 'critical', :due_on => completed_at.to_date + 1.year,
      :key => 'reassessment',
      :description => 'Review your readiness assessment annually.
      To begin, go to your assessment and click "Archive and Re-Assess".'
    }

    if self.reassessment_todo(true)
      reassessment_todo.restart(attrs)
      reassessment_todo
    else
      return organization.todos.create(attrs)
    end
  end

  def self.create_reassessment_todos
    pending_reassessment_todo.find_each do | assessment |
      assessment.create_reassessment_todo
    end
  end

  def self.critical_function_title(critical_function)
    ArtsreadyDomain::CRITICAL_FUNCTIONS.detect do |hash|
      hash[:name] == critical_function
    end.try(:[], :title)
  end

  def initial_critical_functions
    cf = ['people', 'finance', 'technology']
    cf << 'productions' if has_performances?
    cf << 'ticketing' if has_tickets?
    cf << 'facilities' if has_facilities?
    cf << 'programs' if has_programs?
    cf << 'grantmaking' if has_grants?
    cf << 'exhibits' if has_exhibits?
    cf
  end

  def initialize_critical_functions
    previous = organization.assessments.complete.order('completed_at ASC').last
    return unless previous

    self.has_performances = previous.has_performances if self.has_performances.nil?
    self.has_tickets = previous.has_tickets if self.has_tickets.nil?
    self.has_facilities = previous.has_facilities if self.has_facilities.nil?
    self.has_programs = previous.has_programs if self.has_programs.nil?
    self.has_grants = previous.has_grants if self.has_grants.nil?
    self.has_exhibits = previous.has_exhibits if self.has_exhibits.nil?
  end

  def percentage_complete
    # number_to_percentage(((completed_answers_count.to_f / answers_count.to_f)*100),:precision => 0)
    (((completed_answers_count +  skipped_answers_count).to_f / (answers_count).to_f)*100).to_i rescue 0
  end
  
  def skipped_answers_count
    answers.where(:was_skipped => true).count
  end

  def self.critical_function_attribute(function)
    OPTIONAL_CRITICAL_FUNCTION_ATTRIBUTES[function.to_s]
  end

private

  OPTIONAL_CRITICAL_FUNCTION_ATTRIBUTES = {
    'productions' => :has_performances,
    'ticketing' => :has_tickets,
    'facilities' => :has_facilities,
    'programs' => :has_programs,
    'grantmaking' => :has_grants,
    'exhibits' => :has_exhibits
  }

  def populate_empty_answers
    logger.debug("initial critical functions => #{initial_critical_functions}")
    Question.active.each do |q|
      if initial_critical_functions.include?(q.critical_function)
        logger.debug("Adding question #{q.id}, #{q.critical_function}")
        self.answers.create(:question => q) 
      else
        logger.debug("Skipping question #{q.id}, #{q.critical_function}")
        self.answers.create(:question => q, :was_skipped => true)
      end
    end
  end

end
