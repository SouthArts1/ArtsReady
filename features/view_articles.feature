Feature: View articles
  In order to learn things from the site
  As a user
  I want to see the articles

  Background:
    Given a user
    
  Scenario: Public articles should be visible
    Given a public article exists with a title of "Public article"
    When I go to the articles page
    Then I should see "Public article"
  
  Scenario: Private articles should not be visible
    Given a private article exists with a title of "Private article"
    When I go to the articles page
    Then I should not see "Private article"

  Scenario: Disabled articles should not be visible
    Given a disabled article exists with a title of "Disabled article"
    When I go to the articles page
    Then I should not see "Disabled article"
    