Feature: Admin manages access for a user
  In order to help manage a user account
  As a sysadmin
  I want to control the users access to the app

  Background:
    Given a sysadmin
    And an organization with 2 members
  
  Scenario: A sysadmin resets the password
    When I go to the admin organization page
    And I follow the members link
    Then I should be on the admin organization members page
    
  Scenario: A sysadmin disables a user account

  Scenario: A sysadmin enables a user account