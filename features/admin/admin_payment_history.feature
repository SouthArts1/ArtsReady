Feature: Admin payment history

  Scenario: Manage payments
    Given an organization exists with a name of "Paying Org"
    And I am signed in as a sysadmin
    Then I can add a payment for "Paying Org"
    And I can edit the payment for "Paying Org"
