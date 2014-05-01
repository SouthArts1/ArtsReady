Feature: Admin billing management

  Background:
    Given I am signed in as a sysadmin

  Scenario: View billing info
    Given the date is March 19, 2024
    And a paid organization with discount code exists
    Then I should be able to view the organization's billing info

  Scenario: Grant provisional access
    Given an unpaid user exists with an email of "provisional@example.com"
    Then I can grant provisional access

    When I sign out
    Then I can sign in as "provisional@example.com/password"

  Scenario: Update subscription price
    Given a paid organization exists
    Then I can update the organization's subscription price

  Scenario: Update next billing date
    Given a paid organization exists
    Then I can update the organization's next billing date
  Scenario: Subscriptions expire
    Given the following paid organizations exist:
      | Name            | Next Billing Date |
      | Yesterday's Org | March 20, 2025    |
      | Expiring Org    | March 21, 2025    |
      | Renewing Org    | March 21, 2025    |
      | Tomorrow's Org  | March 22, 2025    |
    And I am signed in as a sysadmin
    When the date is March 21, 2025
    And we receive automatic payment notifications for "Renewing Org"
    And the scheduled tasks have run
    Then I should receive an admin expiration notice for "Expiring Org"
