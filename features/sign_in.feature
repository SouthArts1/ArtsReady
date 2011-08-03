Feature: Sign in
  In order to access the app
  As a user
  I want to sign in
  
  Scenario: A member signs in using the correct email and password
  Scenario: A user enters the wrong email address
  Scenario: A user enters the wrong password address
  Scenario: A disabled user tries to sign in
  
  Scenario: A just registered member tries to login
    Given I am a member of an unapproved organization with email "test@test.host" and password "password"
    And I am on the sign_in page
    When I fill in "email" with "test@test.host"
    And I fill in "password" with "password"
    And I press "Sign In"
    Then I should be on the sign_in page
    And I should see "organization has not been approved"
  