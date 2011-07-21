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
  
  scope :for_critical_function, proc {|critical_function| where(:critical_function => critical_function) }
  
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

end