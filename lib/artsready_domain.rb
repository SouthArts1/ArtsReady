module ArtsreadyDomain
  
  CRITICAL_FUNCTIONS = [
    {:name => 'people', :title => 'People Resources', :optional => false},
    {:name => 'finance', :title => 'Finances & Insurance', :optional => false},
    {:name => 'technology', :title => 'Technology', :optional => false},
    {:name => 'productions', :title => 'Productions', :optional => 'We put on performances'},
    {:name => 'ticketing', :title => 'Tickets & Messaging', :optional => 'We manage ticket sales'},
    {:name => 'facilities', :title => 'Facilities', :optional => 'We have our own space/facility'},
    {:name => 'programs', :title => 'Programs', :optional => 'We manage ongoing public programs'},
    {:name => 'grantmaking', :title => 'Grantmaking', :optional => 'We provide grants'},
    {:name => 'exhibits', :title => 'Exhibits', :optional => 'We put on exhibits'}
  ]

  PREPAREDNESS = %w{unknown not_ready needs_work ready}

  PRIORITY = %w{critical non-critical}

end