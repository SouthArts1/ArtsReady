Feature: Admin features a public article
  In order to highlight interesting articles from the library
  As a sysadmin
  I want to feature an article

  Background:
    Given a sysadmin
    And an organization exists
  
  Scenario: Admin can see the admin toolbar with the feature article link 
    Given a public article exists with a title of "A public article"
    When I view the article page for "A public article"
    Then I should see the button "Feature Article?" within "#admin-article-toobar"

  Scenario: Admin can feature a public article
    Given a public article exists with a title of "A public article"
    When I view the article page for "A public article"
    And I press "Feature Article?"
    Then I should see "Article updated"
    And I should see the button "Un-Feature Article?"
    
  Scenario: Admin can un-feature a featured article
    Given a featured article exists with a title of "A featured article"
    When I view the article page for "A featured article"
    And I press "Un-Feature Article?"
    Then I should see "Article updated"
    And I should see the button "Feature Article?"