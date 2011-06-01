Feature: New member 
  In order to become a member
  As a visitor  
  I want to register with the site

  Scenario: A visitor registers and then creates an organization
    Given I am on the home page
    And I follow "Join Today"
    When I fill in "user[first_name]" with "New"
    And I fill in "user[last_name]" with "User"
    And I fill in "user[email]" with "newuser@test.host"
    And I fill in "user[password]" with "password"
    And I fill in "user[password_confirmation]" with "password"
    And I press "user_submit"
    Then I should be on the dashboard page
  
