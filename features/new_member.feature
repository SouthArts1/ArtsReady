Feature: New organization registration
  In order to become a member
  As a visitor  
  I want to register with the site

  Scenario: A visitor registers their organization
    Given I am on the home page
    And I follow "Join Today"
    When I fill in "user[first_name]" with "New"
    And I fill in "user[last_name]" with "User"
    And I fill in "user[email]" with "newuser@test.host"
    And I fill in "user[password]" with "password"
    And I fill in "user[password_confirmation]" with "password"
    And I fill in "user[organization_attributes][name]" with "My Org"
    And I fill in "user[organization_attributes][address]" with "100 Test St"
    And I fill in "user[organization_attributes][city]" with "New York"
    And I fill in "user[organization_attributes][state]" with "NY"
    And I fill in "user[organization_attributes][zipcode]" with "10001"
    And I press "user_submit"
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
