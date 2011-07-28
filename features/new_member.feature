Feature: New organization registration
  In order to become a member
  As a visitor  
  I want to register with the site

  Scenario: A visitor registers their organization
    Given I am on the home page
    When I follow "Join Today"
    And I fill in "organization[name]" with "My Org"
    And I fill in "organization[address]" with "100 Test St"
    And I fill in "organization[city]" with "New York"
    And I fill in "organization[state]" with "NY"
    And I fill in "organization[zipcode]" with "10001"
    And I fill in "organization[users_attributes][0][first_name]" with "New"
    And I fill in "organization[users_attributes][0][last_name]" with "User"
    And I fill in "organization[users_attributes][0][email]" with "newuser@test.host"
    And I fill in "organization[users_attributes][0][password]" with "password"
    And I fill in "organization[users_attributes][0][password_confirmation]" with "password"
    And show me the page
    And I press "Create Organization"
    Then I should be on the welcome page
    And I should see "organization has been registered and is awaiting approval"
  
  Scenario: A just registered member tries to login
    Given I am a member of an unapproved organization with email "test@test.host" and password "password"
    And I am on the sign_in page
    When I fill in "email" with "test@test.host"
    And I fill in "password" with "password"
    And I press "Sign In"
    Then I should be on the sign_in page
    And I should see "organization has not been approved"
