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
  
  Scenario: Admin deletes a message
    Given the following messages exist:
      | organization_id | content   | visibility |
      | Crisis Org      | "Hi Mom!" | public     |
      | Crisis Org      | "Hi Dad!" | public     |
    And I am signed in as a sysadmin
    And I am on the Lend-a-Hand page
    When I press "Delete"
    Then I should be on the Lend-a-Hand page
    And I should not see "Hi Dad!"
    And I should see "Hi Mom!"
  

  
