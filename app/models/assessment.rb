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

  def percentage_complete
    # number_to_percentage(((completed_answers_count.to_f / answers_count.to_f)*100),:precision => 0)
    ((completed_answers_count.to_f / answers_count.to_f)*100).to_i rescue 0
  end

  def populate_empty_answers
    Question.all.each do |q|
      self.answers.create(:question => q, :critical_function => q.critical_function)
    end
  end

end