Feature: Public articles can be disabled
  In order to suppress inappropriate content
  As a sysadmin
  I want to disable articles
  
  Background:
    Given a sysadmin
    And an organization exists
  
  Scenario: Admin can see the admin toolbar with the feature article link 
    Given a public article exists with a title of "A public article"
    When I view the article page for "A public article"
    Then I should see the button "Disable Article?" within "#admin-article-toolbar"

  Scenario: Admin can disable a public article
    Given a public article exists with a title of "A public article"
    When I view the article page for "A public article"
    And I press "Disable Article?"
    Then I should see "disabled article"
    
  Scenario: Admin can re-enable a disabled article
    Given a disabled article exists with a title of "A disabled article"
    When I view the admin article page for "A disabled article"
    And I press "Enable Article?"
    Then I should see "Article updated"
    When I view the article page for "A disabled article"
    Then I should see the button "Disable Article?" within "#admin-article-toolbar"