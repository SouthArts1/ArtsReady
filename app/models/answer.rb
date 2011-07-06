class Answer < ActiveRecord::Base

  belongs_to :assessment
  belongs_to :question
  belongs_to :organization
  has_many :todos
  has_many :action_items, :through => :question

  delegate :description, :to => :question, :allow_nil => true, :prefix => true

  validates_presence_of :assessment
  validates_presence_of :question
  validates_presence_of :preparedness
  validates_presence_of :priority


  after_update :add_todo_items

  def ready?
    self.preparedness=='ready'
  end

  def add_todo_items
    question.action_items.each do |i|
      todos.create(:action_item => i, :organization => assessment.organization, :description => i.description) unless ready?
      logger.debug("Adding todo #{i.description} for question #{question.description}") unless ready?
    end
  end

end