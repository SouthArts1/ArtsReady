Feature: Admin features a public article
  In order to highlight interesting articles from the library
  As a sysadmin
  I want to feature an article

  Scenario: Admin can see the feature article link 
    Given a sysadmin
    And an organization exists
    And a public article exists with a title of "A public article"
    When I view the article page for "A public article"
    And show me the page  
    Then I should see the button "Feature Article?" within "#admin-article-toobar"
    
  Scenario: Admin can unfeature a public article
  Scenario: Admin cannot feature a private article
