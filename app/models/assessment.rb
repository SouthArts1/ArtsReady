class Assessment < ActiveRecord::Base

  belongs_to :organization
  has_many :answers, :dependent => :destroy
  has_many :todos, :through => :answers

  attr_accessor :critical_functions

  validates_presence_of :organization

  after_create :populate_empty_answers

  CRITICAL_FUNCTIONS = [
    {:name => 'people', :title => 'People Resources', :optional => false},
    {:name => 'finance', :title => 'Finances & Insurance', :optional => false},
    {:name => 'tech', :title => 'Technology', :optional => false},
    {:name => 'performances', :title => 'Productions', :optional => 'We put on performances'},
    {:name => 'tickets', :title => 'Tickets & Messaging', :optional => 'We manage ticket sales'},
    {:name => 'facilities', :title => 'Facilities', :optional => 'We have our own space/facility'},
    {:name => 'programs', :title => 'Programs', :optional => 'We manage ongoing public programs'},
    {:name => 'grants', :title => 'Grantmaking', :optional => 'We provide grants'},
    {:name => 'exhibits', :title => 'Exhibits', :optional => 'We put on exhibits'}
  ]
  
  def is_complete?
    complete
  end
  
  def percentage_complete
    completed_answers_count/answers_count rescue 0
  end

  def populate_empty_answers
    Question.all.each do |q|
      self.answers.create(:question => q)
    end
  end

end