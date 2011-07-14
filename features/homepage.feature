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
    When I go to the root page
    Then I should see "Library"
    # And I should see at least one featured article
    
  Scenario: A visitor can register
    Given a visitor
    When I go to the root page
    Then I should see "Join Today"
    
  Scenario: redirect to member home if logged in
    Given an authenticated user
    When I go to the root page
    Then I should be on the dashboard page
    
  Scenario: crisis user is redirected to crisis console
    Given a crisis user
    When I go to the root page
    Then I should see "Crisis Console"
    #Then I should be on the crisis console