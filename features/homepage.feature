Feature: Homepage
  In order to learn more about ArtsReady
  As a visitor
  I want to learn more about the site
  
  Scenario: featured library content
    Given I am on the home page
    Then I should see "Library"
    
  Scenario: join
    Given I am on the home page
    Then I should see "Join Today"
  
  