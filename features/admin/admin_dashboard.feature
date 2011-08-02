Feature: Admin dashboard
  In order to manage the application
  As a sysadmin
  I want to get an overview of things that need attention
  
  Scenario: A sysadmin is directed to the admin dashboard
    Given I am a sysadmin with email "admin@test.host"
    And I am on the sign_in page
    And fill in "email" with "admin@test.host"
    And fill in "password" with "password"
    And I press "Sign In"
    Then I should be on the admin dashboard page
    