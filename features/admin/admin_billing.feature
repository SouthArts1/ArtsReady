Feature: Admin billing management

  Scenario: View billing info
    Given the date is March 19, 2014
    And a paid organization with discount code exists
    And I am signed in as a sysadmin
    Then I should be able to view the organization's billing info
