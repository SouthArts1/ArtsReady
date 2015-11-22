module ArtsreadyDomain
  
  CRITICAL_FUNCTIONS = [
    {:name => 'people', :title => 'People Resources', :optional => false},
    {:name => 'finance', :title => 'Finances & Insurance', :optional => false},
    {:name => 'technology', :title => 'Technology', :optional => false},
    {:name => 'productions', :title => 'Productions', :optional => 'We put on performances'},
    {:name => 'ticketing', :title => 'Tickets & Messaging', :optional => 'We manage ticket sales and messaging'},
    {:name => 'facilities', :title => 'Facilities', :optional => 'We have our own space/facility'},
    {:name => 'programs', :title => 'Programs', :optional => 'We manage ongoing public programs'},
    {:name => 'grantmaking', :title => 'Grantmaking', :optional => 'We provide grants'},
    {:name => 'exhibits', :title => 'Exhibits', :optional => 'We put on exhibits'}
  ]

  MEMBER_LIBRARY_TOPICS = CRITICAL_FUNCTIONS + [
    {:name => 'before_and_after', :title => 'Before and After a Crisis'},
    {:name => 'general', :title => 'General Resources'}
  ]

  LIBRARY_TOPICS = MEMBER_LIBRARY_TOPICS + [
    {:name => 'newsletters', :title => 'ArtsReady eNewsletters'},
    {:name => 'events', :title => 'ArtsReady Workshops and Webinars'},
  ]

  PREPAREDNESS = %w{unknown not_ready needs_work ready}
  PRIORITY = %w{critical non-critical}
  TODO_STATUS = ['Not Started', 'In Progress', 'Complete']
  ROLES = %w{reader editor executive manager}
  
  ORGANIZATIONAL_STATUSES = [
    '02 Organization - Non-profit',
    '03 Organization - Profit',
    '04 Government - Federal',
    '05 Government - State',
    '06 Government - Regional',
    '07 Government - County',
    '08 Government - Municipal',
    '09 Government - Tribal'
  ]
  
  OPERATING_BUDGETS = [
  'More than $1,000,000',
  'Less than $1,000,000'
  ]
  
  NSIC_CODES = [
    '03 Performing Group',
    '04 Performing Group- College/University',
    '05 Performing Group- Community',
    '06 Performing Group- Youth',
    '07 Performance Facility',
    '08 Art Museum',
    '09 Other Museum',
    '10 Gallery/Exhibit Space',
    '11 Cinema',
    '12 Independent Press',
    '13 Literary Magazine',
    '14 Fair/Festival',
    '15 Arts Center',
    '16 Arts Council/Agency',
    '17 Arts Service Organization',
    '27 Library',
    '28 Historical Society',
    '29 Humanities Council',
    '30 Foundation',
    '31 Corporation',
    '32 Community Service Organization',
    '47 Cultural Series Organization/Presenters',
    '48 School of the Arts',
    '49 Arts Camp/Institute'
  ]
  # Statuses:
  # Not Started
  # In Progress
  # Complete
  # 
  # Default Statuses:
  # Action Item Created by Assessment:
  # ...if Question status marked as "ready", "not ready" or "needs work": "In Progress"
  # ...if Question status marked as "unknown": "Not Started"
  # Action Item Created by User: "Not Started"

end