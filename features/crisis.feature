Feature: Crisis
  In order to get help from my battle buddies
  As an admin
  I want to manage a crisis
  
  Background:
  
  Scenario: Admin declares a crisis
    Given an authenticated user
    And I am on the dashboard page
    And I am not in crisis mode
    When I declare a crisis
    Then I am in crisis mode
  
  Scenario: Admin resolves a crisis
    Given a crisis user
    And I am on the dashboard page
    And I am in crisis mode
    # And I should be on the crisis_console page
    When I resolve a crisis
    Then I am not in crisis mode