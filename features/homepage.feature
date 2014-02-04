Feature: Homepage
  In order to learn more about ArtsReady
  As a visitor
  I want to learn more about the site
  
  Scenario: home/index for visitors
    Given a visitor
    When I go to the root page
    Then I should be on the home page

  Scenario: A visitor can see featured library content
    Given a visitor
    And the following public article exists:
      | title          | featured |
      | important info | true     |
    When I go to the root page
    And I follow "Library"
    Then I should see "important info"

  Scenario: Deactivated orgs should not be featured on the readiness library
    Given a visitor
    And the following deactivated org exists:
      | name   | active |
      | BadOrg | false  |
    And the following public article exists:
      | title     | featured |
      | Bad stuff | true     |
    And that article belongs to the organization BadOrg
    When I go to the root page
    And I follow "Library"
    Then I should not see "Bad stuff"

  Scenario: A visitor can register
    Given a visitor
    When I go to the root page
    Then I should see "Join the Movement"
    
  Scenario: redirect to member home if logged in
    Given a user
    When I go to the root page
    Then I should be on the dashboard page
    
  Scenario: crisis user is redirected to crisis console
    Given a crisis user
    When I go to the root page
    Then I should see "Crisis Console"
    
  Scenario: Create assessment
    Given a user
    And I am on the home page
    When I follow "Get Started"
    Then I should be on the new assessment page

  Scenario: Continue assessment
    Given a user
    And I have started an assessment
    And I am on the home page
    When I follow "Continue"
    Then I should be on the assessment page

  Scenario: Finished assessment
    Given a user
    And I have finished an assessment
    And I am on the home page
    Then I should not see "Get Started"
