Feature: Admin email template management

  Scenario: Edit a template
    Given I am signed in as a sysadmin
    Then I can edit the "renewal reminder" email template
    And I can preview the "renewal reminder" email template

  Scenario: Preview the credit card expiration template
    Given I am signed in as a sysadmin
    And a credit card expiration template exists
    Then I can preview the "credit card expiration" email template
