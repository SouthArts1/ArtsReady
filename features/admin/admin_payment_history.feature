Feature: Admin payment history

  Background:
    Given a paid organization exists with a name of "Paying Org"
    And I am signed in as a sysadmin

  Scenario: Manage payments
    Then I can add a payment for "Paying Org"
    And I can edit the payment for "Paying Org"
    And I can delete the payment for "Paying Org"

  Scenario: Manage payments by check
    When I add a payment by check for "Paying Org"
    Then I can extend the next billing date for "Paying Org" by 365 days

  Scenario: Automatic payment notification
    When we receive automatic payment notifications for "Paying Org"
    Then I can view the automatic payment details for "Paying Org"
    And the next billing date for "Paying Org" is extended by 365 days
