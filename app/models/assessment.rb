class Assessment < ActiveRecord::Base
  belongs_to :organization
  
  attr_accessor :critical_functions
  
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
  
end
