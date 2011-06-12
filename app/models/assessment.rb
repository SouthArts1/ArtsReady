class Assessment < ActiveRecord::Base
  belongs_to :organization
  
  attr_accessor :critical_functions
  
  CRITICAL_FUNCTIONS = [
    {:title => 'People Resources', :optional => false},
    {:title => 'Finances &amp; Insurance', :optional => false},
    {:title => 'Technology', :optional => false},
    {:title => 'Productions', :optional => 'We put on performances'},
    {:title => 'Tickets &amp; Messaging', :optional => 'We manage ticket sales'},
    {:title => 'Facilities', :optional => 'We have our own space/facility'},
    {:title => 'Programs', :optional => 'We manage ongoing public programs'},
    {:title => 'Grantmaking', :optional => 'We provide grants'},
    {:title => 'Exhibits', :optional => 'We put on exhibits'}
  ]
  
end
