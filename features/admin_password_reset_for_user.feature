Feature: Admin password reset for user
  In order to help manage a user account
  As a sysadmin
  I want to reset the password for a user
  
  Scenario: A sysadmin resets the password
    Given a sysadmin
    And an organization with 2 members
    When I go to the admin organization page
    And show me the page
    And I follow the members link
    Then I should be on the admin organization members page  