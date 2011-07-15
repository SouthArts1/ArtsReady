Feature: Crisis message
  In order communicate with my battle buddies during a crisis
  As a member
  I want to send messages
  
  @todo
  Scenario: Crisis user posts a message
    Given a crisis user
    And I am on the crisis console
    When I fill in "update[message]" with "some message"
    And I press "Report"
    And I should see "some message"
    #Then I should be on the crisis console
  
  
  

  
