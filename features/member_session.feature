Feature: Member session
  In order to use the site
  As a member
  I want manage my session

  Scenario: User logins in successfully
    Given a member with email "test@test.host" and password "password"
    And I am on the sign_in page
    When I fill in "email" with "test@test.host"
    And I fill in "password" with "password"
    And I press "Sign In"
    Then I should be on the dashboard page
  
  Scenario: User logins in with bad password
    Given a member with email "test@test.host" and password "password"
    And I am on the sign_in page
    When I fill in "email" with "test@test.host"
    And I fill in "password" with "badpassword"
    And I press "Sign In"
    Then I should be on the sign_in page
    And I should see "Invalid email or password"
    
  Scenario: User logs out
    Given a member with email "test@test.host" and password "password"
    And I am on the sign_in page
    And I fill in "email" with "test@test.host"
    And I fill in "password" with "password"
    And I press "Sign In"
    And I am on the dashboard page
    When I follow "Logout"
    Then I should be on the home page
  
  
  
  
  
  

  
