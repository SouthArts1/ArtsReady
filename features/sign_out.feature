Feature: Sign out
  To protect my account from unauthorized access
  A signed in user
  Should be able to sign out

  Scenario: User signs out
    Given the following user exists:
      | email           | password |
      | valid@test.host | password |
    When I sign in as "valid@test.host/password"
    Then I should be signed in
    And I sign out
    Then I should see "Logged out"
    And I should be signed out
    When I return next time
    Then I should be signed out
