class Assessment < ActiveRecord::Base
  belongs_to :organization
  
  attr_accessor :options
  
  CHOICES = {
    :space => 'We have our own space/facility', 
    :tickets => 'We manage ticket sales', 
    :performances => 'We put on performances', 
    :exhibits => 'We put on exhibits', 
    :programs => 'We manage ongoing public programs', 
    :grants => 'We provide grants' }
  
end
