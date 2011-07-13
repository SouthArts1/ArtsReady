Feature: Crisis
  In order to get help from my battle buddies
  As an admin
  I want to manage a crisis
  
  Background:
  
  Scenario: Admin declares a crisis
    Given an authenticated user
    And I am on the dashboard page
    Then show me the page
    And I am not in crisis mode
    When I declare a crisis
    Then I should be in crisis mode
  
  Scenario: Admin resolves a crisis
    When I declare a crisis
    Then I should be in crisis mode
    When I resolve a crisis
    Then I should not be in crisis mode