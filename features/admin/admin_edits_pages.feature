Feature: Admin edits pages
  In order to manage the public site content
  As an admin
  I want to edit the content of public pages
  
  Background:
    Given a sysadmin
    And a page exists with a title of "Test Page"

  Scenario: An admin can manage pages from the dashboard
    Given I am on the admin dashboard page
    Then I should see "Manage Pages"
    
    When I follow "Manage Pages"
    Then I should be on the admin pages page
    
  Scenario: An admin can edit a page
    Given I am on the admin pages page
    When I follow "Test Page"
    Then I should see "Edit Public Page"

    When I fill in "page[body]" with "NEW CONTENT"
    And I press "Save"
    Then I should see "Page updated"
    And I should be on the admin pages page
    And I should see "NEW CONTENT"