Feature: Crisis console
  In order to get help from my battle buddies
  As an admin
  I want to manage a crisis from my crisis console
  
  @todo
  Scenario: Admin declares a crisis
    Given a user
    And I am on the dashboard page
    And I have a Battle Buddy
    And I am not in crisis mode
    When I declare a crisis
    Then I am in crisis mode
  
  @todo
  Scenario: Admin resolves a crisis
    Given a crisis user
    And I am on the dashboard page
    And I am in crisis mode
    # And I should be on the crisis_console page
    When I resolve a crisis
    Then I am not in crisis mode
    
    
  Scenario: User does not see crisis console when not in crisis
    Given a user
    And I am on the lend a hand page
    Then I should not see "Crisis Console"
    And I am on the get help page
    Then I should not see "Crisis Console"
    And I am on the profile page
    Then I should not see "Crisis Console"
  
  
  Scenario: Crisis user can see crisis console
    Given a crisis user
    And I am on the lend a hand page
    Then I should see "Crisis Console"
    And I am on the get help page
    Then I should see "Crisis Console"
    And I am on the profile page
    Then I should see "Crisis Console"
  
