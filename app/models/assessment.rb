class Assessment < ActiveRecord::Base

  belongs_to :organization
  has_many :answers, :dependent => :destroy
  has_many :todos, :through => :answers

  attr_accessor :critical_functions

  validates_presence_of :organization

  after_create :populate_empty_answers

  def is_complete?
    return false unless answers_count > 0
    (completed_answers_count + skipped_answers_count) == answers_count
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

  def increment_completed_answers_count
    update_attribute(:completed_answers_count, completed_answers_count + 1)
  end

  def percentage_complete
    # number_to_percentage(((completed_answers_count.to_f / answers_count.to_f)*100),:precision => 0)
    (((completed_answers_count +  skipped_answers_count).to_f / (answers_count).to_f)*100).to_i rescue 0
  end
  
  def skipped_answers_count
    answers.skipped.size
  end

  def section_progress_for(function)
    [
      answers.for_critical_function(function).answered.size,
      answers.for_critical_function(function).not_skipped.size
    ]
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
        self.answers.create(:question => q) 
      end
    end
  end

end
