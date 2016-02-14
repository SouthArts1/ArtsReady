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

  Scenario: An admin can create a page
    Given I am on the admin pages page
    When I follow "Create a new Page"
    Then I should see "New Public Page"

    And I fill in "Slug" with "newpage"
    And I fill in "Title" with "A New Page"
    When I fill in "Body" with "New page content."
    And I press "Save"
    Then I should see "Page created"

    When I follow "A New Page"
    And I follow "/page/newpage"
    Then I should see "A New Page"
    And I should see "New page content."

  Scenario: An admin can edit a page
    Given I am on the admin pages page
    When I follow "Test Page"
    Then I should see "Edit Public Page"

    When I fill in "page[body]" with "NEW CONTENT"
    And I press "Save"
    Then I should see "Page updated"
    And I should be on the admin pages page
    And I should see "NEW CONTENT"

  Scenario: An admin can delete a page
    Given the following page exists:
      | Slug      | Title     | Body               |
      | delete-me | Delete Me | Delete me, please. |
    And I am on the admin pages page
    When I follow "Delete Me"
    And I press "Delete This Page"
    Then I should be on the admin pages page
    And I should not see "Delete Me"

  Scenario: An admin can modify the home page
    Given I am on the admin pages page
    When I follow "Create a new Page"
    And I fill in "Slug" with "home"
    And I fill in "Title" with "Home Page"
    And I fill in "Body" with "<h1>Hey</h1>"
    And I press "Save"

    When I follow "Logout"
    Then I should see "Hey" within "#landing h1"
    And I should not see "Be ArtsReady"

    When I sign in as "admin@test.host/password"
    And I go to the admin pages page
    And I follow "Home Page"
    And I press "Delete This Page"

    When I follow "Logout"
    Then I should see "Be ArtsReady" within "#landing h1"
    And I should not see "Hey"
