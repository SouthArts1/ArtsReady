class Todo < ActiveRecord::Base
  belongs_to :action_item
  belongs_to :answer
  belongs_to :organization
  belongs_to :user
  belongs_to :last_user, :class_name => 'User'
  has_many :articles
  has_many :todo_notes, -> { order('created_at ASC') }, :dependent => :destroy

  validates_presence_of :description
  validates_presence_of :critical_function
  validates_presence_of :priority

  delegate :name, :to => :user, :allow_nil => true, :prefix => true
  delegate :preparedness, :to => :answer, :allow_nil => true, :prefix => false
  delegate :recurrence, :to => :action_item, :allow_nil => true, :prefix => false
  delegate :title, :to => :critical_function, :prefix => true

  before_save :set_status
  before_update :check_user_change
  before_create :initialize_action
  after_create :send_assignment_email, :add_create_note
  after_update :add_update_note

  scope :for_critical_function, proc {|critical_function| where(:critical_function => critical_function) }
  scope :in_action_order, -> { order('complete') }
  scope :completed, -> { where(:complete => true) }
  scope :nearing_due_date, lambda {
    where("complete IS NOT true AND due_on <= ?", Time.zone.today + 2.days)
  }

  PRIORITY = ['critical', 'non-critical']
  NEXT_ACTIONS = { 'Review' => 'ready', 'Start' => 'not ready', 'Learn About' => 'unknown', 'Work On' => 'needs work' }

  TRACKED_ATTRIBUTES = %w{description critical_function priority due_on review_on completed status action}
  
  def action_description
    "#{action} #{description}"
  end
  
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
    if user_id_changed?
      send_reassignment_email
      send_assignment_email
    end
  end

  def send_reassignment_email
    begin
      TodoMailer.reassign_to(User.find(user_id_was), self).deliver
    rescue ActiveRecord::RecordNotFound
      logger.debug("Mail could not be sent because user was nil.")
    rescue
      logger.debug("General Mailer error: #{exc.message}")
    end
  end

  def send_assignment_email
    begin
      TodoMailer.assign_to(user, self).deliver
    rescue Exception => exc
      if !user
        logger.debug("Mail could not be sent because user was nil.")
      else
        logger.debug("General Mailer error: #{exc.message}")
      end
    end
  end
  
  def related_assessment_question
    action_item.question.description rescue ""
  end

  def related_assessment_question_help
    RedCloth.new(action_item.question.help).to_html.html_safe rescue ""
  end

  def critical_function_title
    Assessment.critical_function_title(critical_function)
  end

  def self.create_or_restart(attributes)
    matching_attributes = {
      :organization_id => attributes[:organization].id,
      :action_item_id => attributes[:action_item].id
    }
    existing = unscoped.where(matching_attributes).first
    
    if existing
      matching_keys = matching_attributes.keys
      existing.restart(attributes.reject { |k, v| matching_keys.include? k })
      existing
    else
      create(attributes.merge(matching_attributes))
    end
  end

  def restart(attributes = {})
    @restart_in_progress = true
    update_attributes(attributes.reverse_merge(
      :complete => false, :due_on => nil, :user_id => nil ))
    initialize_action
    save
  ensure
    @restart_in_progress = false
    self
  end
  
  def reminder_recipients
    user ? [user] : organization.managers
  end

  def recipient_name
    user ? user.name : organization.name
  end

  private
  
  def add_create_note
    todo_notes.create(:user_id => last_user_id, :message => "Created")
  end

  def add_update_note
    messages = []
    self.changes.each do |key, value|
      messages << "'#{key.humanize}' changed from #{value[0].presence || 'nothing'} to #{value[1].presence || 'nothing'}" if TRACKED_ATTRIBUTES.include?(key)
    end
    messages << "Assigned to #{user_name}" if self.changes["user_id"]

    message = messages.join('; ')

    if @restart_in_progress
      message = message.present? ? "Restarted: #{message}" : 'Restarted'
    end
    todo_notes.create(:user_id => last_user_id, :message => message) if message.present?
  end
  
  def initialize_action
    self.action = NEXT_ACTIONS.invert[preparedness] if preparedness
  end
end
