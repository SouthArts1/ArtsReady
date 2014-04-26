Feature: Admin billing management

  Scenario: View billing info
    Given the date is March 19, 2024
    And a paid organization with discount code exists
    And I am signed in as a sysadmin
    Then I should be able to view the organization's billing info

  Scenario: Grant provisional access
    Given an unpaid user exists with an email of "provisional@example.com"
    And I am signed in as a sysadmin
    Then I can grant provisional access

    When I sign out
    Then I can sign in as "provisional@example.com/password"

  Scenario: Update subscription price
    Given a paid organization exists
    And I am signed in as a sysadmin
    Then I can update the organization's subscription price
