Feature: Sign in
  In order to access the app
  As a user
  I want to sign in
  
  Background:
    Given the following user exists:
      | email           | password |
      | valid@test.host | password |

  Scenario: User is not signed up
    When I go to the sign in page
    And I sign in as "email@person.com/password"
    Then I should see "Invalid email or password"
    And I should be signed out

  Scenario: A member signs in using the correct email and password
    When I go to the sign in page
    And I sign in as "valid@test.host/password"
    Then I should see "Logged in"
    And I should be signed in
    When I return next time
    Then I should be signed in

  Scenario: A user enters the wrong email address
    When I go to the sign in page
    And I sign in as "invalid@test.host/password"
    Then I should see "Invalid email or password"
    And I should be signed out

  Scenario: A user enters the wrong password address
    When I go to the sign in page
    And I sign in as "valid@test.host/badpassword"
    Then I should see "Invalid email or password"
    And I should be signed out

  Scenario: A disabled user tries to sign in
    Given a disabled user exists with an email of "disabled@test.host"
    When I go to the sign in page
    And I sign in as "disabled@test.host/password"
    Then I should see "Account has been disabled by an administrator"
    And I should be signed out
  
  Scenario: A just registered member tries to login
    Given I am a member of an unapproved organization with email "test@test.host" and password "password"
    And I am on the sign_in page
    When I fill in "email" with "test@test.host"
    And I fill in "password" with "password"
    And I press "Sign In"
    Then I should be on the new billing page

    When I fill out and submit the billing form
    Then I should be on the dashboard

  Scenario: A user tries to access a page without signing in
    When I go to the lend a hand page
    Then I should be on the sign in page
    And I should see "You must sign in to access that page"

