class Todo < ActiveRecord::Base
  belongs_to :action_item
  belongs_to :answer
  belongs_to :organization
  belongs_to :user
  has_many :articles
  has_many :todo_notes

  validates_presence_of :description
  validates_presence_of :critical_function
  validates_presence_of :priority
  
  delegate :name, :to => :user, :allow_nil => true, :prefix => true
  delegate :recurrence, :to => :action_item, :allow_nil => true, :prefix => false
  
  before_save :set_status
  before_save :check_user_change
  after_create :send_assignment_email
  
  scope :for_critical_function, proc {|critical_function| where(:critical_function => critical_function) }
  scope :completed, where(:complete => true)
  
  PRIORITY = ['critical', 'non-critical']
  PREPAREDNESS = ['not-ready', 'needs work', 'ready', 'unknown']
  
  def set_status
    if answer.nil?
      self.status = 'Not Started'
    elsif answer.present? && answer.preparedness.downcase=='unknown'
      self.status = 'Not Started'
    else
      self.status = 'In Progress'
    end

    self.status = 'Complete' if complete?
  end
  
  def check_user_change
    old_todo = Todo.find(self.id)
    if old_todo
      if old_todo.user != self.user
        self.send_assignment_email
      end
    end
  end
  
  def send_assignment_email
    logger.debug("Firing email")
    begin !self.user.nil?
      TodoMailer.todo_mailer(self.user, self).deliver
    rescue Exception => exc
      if self.user.nil?
        logger.debug("Mail could not be sent because user was nil.")
      else
        logger.debug("General Mailer error: #{exc.message}")
      end
    end
  end

end