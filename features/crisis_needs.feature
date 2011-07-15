Feature: Crisis needs
  In order to get the help I need
  As a user in crisis
  I want to let my battle buddies know what I need

  Scenario: See a list of my needs
    Given a crisis user
    When I am on the crisis console
    Then I should see "Your Needs"

  Scenario: Add something I need
    Given a crisis user
    When I am on the crisis console
    And I fill in "need[resource]" with "A resource"
    And I fill in "need[description]" with "The description"
    And I press "Add"
    Then I should be on the crisis console
    And I should see "A resource"
    And I should see "The description"
  