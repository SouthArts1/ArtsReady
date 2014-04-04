Feature: Admin payment history

  Scenario: Add a payment
    Given an organization exists with a name of "Paying Org"
    And I am signed in as a sysadmin
    Then I can add a payment for "Paying Org"
