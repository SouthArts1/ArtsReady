class Assessment < ActiveRecord::Base

  belongs_to :organization
  has_many :answers, :dependent => :destroy
  has_many :todos, :through => :answers

  attr_accessor :critical_functions

  validates_presence_of :organization

  after_create :populate_empty_answers

  def is_complete?
    complete
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

  def percentage_complete
    # number_to_percentage(((completed_answers_count.to_f / answers_count.to_f)*100),:precision => 0)
    (((completed_answers_count +  skipped_answers_count).to_f / (answers_count).to_f)*100).to_i rescue 0
  end
  
  def skipped_answers_count
    answers.where(:was_skipped => true).count
  end

  def populate_empty_answers
    logger.debug("initial critical functions => #{initial_critical_functions}")
    Question.active.each do |q|
      if initial_critical_functions.include?(q.critical_function)
        logger.debug("Adding question #{q.id}, #{q.critical_function}")
        self.answers.create(:question => q, :critical_function => q.critical_function) 
      else
        logger.debug("Skipping question #{q.id}, #{q.critical_function}")
        self.answers.create(:question => q, :critical_function => q.critical_function, :was_skipped => true) 
      end
    end
  end

end