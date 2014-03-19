Feature: Admin billing management

  Scenario: View billing info
    Given a paid organization exists
    And I am signed in as a sysadmin
    Then I should be able to view the organization's billing info
