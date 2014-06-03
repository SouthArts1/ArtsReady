Feature: Admin notes

  Background:
    Given I am signed in as a sysadmin

  Scenario: Manage notes
    Given an organization exists with a name of "Note Org"
    Then I can add a note for "Note Org"
    And I can add payment info to the note for "Note Org"
