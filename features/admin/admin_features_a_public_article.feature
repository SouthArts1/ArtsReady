Feature: Admin features a public article
  In order to highlight interesting articles from the library
  As a sysadmin
  I want to feature an article

  Scenario: Admin can see the feature article link 
    Given a sysadmin
    And an organization exists
    And a public article exists
    When I go to the public library page
    Then I should see "Feature this Article"
    
  Scenario: Admin can unfeature a public article
  Scenario: Admin cannot feature a private article
