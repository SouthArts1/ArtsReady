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
    # On the first day, the billing info page shows starting amount,
    # so we can't use it to verify changes to recurring amount.
    And a day has passed
    Then I can update the organization's subscription price

  Scenario: Update next billing date
    Given a paid organization exists
    Then I can update the organization's next billing date

  Scenario: Update provisional subscription
    Given a provisional organization exists
    Then I can update the organization's subscription price
    And I can update the organization's next billing date

  Scenario: Monthly admin notifications
    Given today is the first of the month
    Given the following organization exists:
      | Name    | Member Count | Renewing in |
      | Renewer | 1            | 45 days     |
    And the following expiring organization exists:
      | Name    | Member Count |
      | Expirer | 1            |
    And I have paid for my subscription
    And the scheduled tasks have run
    Then admins should receive a renewing organizations notice for "Renewer"
    And admins should receive an expiring credit card admin notice for "Expirer"

  Scenario: Subscriptions expire
    Given the following paid organizations exist:
      | Name            | Next Billing Date |
      | Yesterday's Org | March 20, 2025    |
      | Expiring Org    | March 21, 2025    |
      | Renewing Org    | March 21, 2025    |
      | Tomorrow's Org  | March 22, 2025    |
    When the date is March 21, 2025
    And we receive automatic payment notifications for "Renewing Org"
    And the scheduled tasks have run
    Then admins should receive an admin expiration notice for "Expiring Org"
