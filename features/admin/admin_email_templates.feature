Feature: Admin email template management

  Scenario: Edit a template
    Given I am signed in as a sysadmin
    Then I can edit the "renewal receipt" email template
    And I can preview the "renewal receipt" email template
