Feature: Admin payment history

  Background:
    Given I am signed in as a sysadmin

  Scenario: Manage payments
    Given a paid organization exists with a name of "Paying Org"
    Then I can add a payment for "Paying Org"
    And I can edit the payment for "Paying Org"
    And I can delete the payment for "Paying Org"

  Scenario: Manage payments by check
    Given an unpaid organization exists with a name of "Unpaid Org"
    When I add a payment by check for "Unpaid Org"
    Then I can extend the next billing date for "Unpaid Org" by 365 days

  Scenario: Automatic payment notification
    Given a paid organization exists with a name of "Paying Org"
    When the time is "3:18 PM" on "March 20, 2024"
    And we receive automatic payment notifications for "Paying Org"
    Then I can view the automatic payment details for "Paying Org"
    And the next billing date for "Paying Org" is extended by 365 days
