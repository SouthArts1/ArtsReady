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
    Then I should see the button "Disable Article?" within "#admin-article-toobar"

  Scenario: Admin can disable a public article
    Given a public article exists with a title of "A public article"
    When I view the article page for "A public article"
    And I press "Disable Article?"
    Then I should see "disabled article"
    And I should see the button "Enable Article?" within "#admin-article-toobar"
    
  Scenario: Admin can re-enable a featured article
    Given a disabled article exists with a title of "A disabled article"
    When I view the article page for "A disabled article"
    And I press "Enable Article?"
    Then I should see "Article updated"
    And I should see the button "Disable Article?" within "#admin-article-toobar"