Feature: Admin organization management
  In order to improve and assess usage
  As an admin
  I want to manage the organization list

  Scenario: List organizations
    Given 2 questions exist
    Given the following organization exists:
      | Name  | Member Count | Completed Answers Count | To Do Usage | Active |
      | MyOrg | 1            | 1                       | 1/2         | true   |
      | NoOrg | 2            | 1                       | 1/2         | false  |
    And the following sysadmin exists:
      | Organization | Email             |
      | Name: MyOrg  | admin@example.org |
    And I am signed in as "admin@example.org"

    When I follow "Manage Organizations"
    Then I should see the following organizations:
      | Name  | Members   | Assessment % | To-Do % |
      | MyOrg | 2 members | 50%          | 50%     |
      # 2 members including the admin
    And I should not see "NoOrg"
    When I follow "2 members"
    Then I should see "Last Login"

  Scenario: List disabled organizations
    Given the following organizations exist:
      | Name         | Active |
      | MyOrg        | true   |
      | disabledOrg  | false  |
    And I am signed in as a sysadmin
    When I follow "Manage Organizations"
    And I follow "Disabled"
    Then I should see "disabledOrg"
    And I should not see "MyOrg"

  Scenario: Delete organization
    Given the following organization exists:
      | Name   | Active |
      | MyOrg  | false  |
    And all users for "MyOrg" are disabled
    And the following articles exist:
      | Organization | Title        | Visibility |
      | Name: MyOrg  | Secret Stuff | executive  |
      | Name: MyOrg  | Open Stuff   | public     |
    And I am signed in as a sysadmin

    When I visit the disabled organizations page
    And I delete the organization "MyOrg"
    Then the organization "MyOrg" should be deleted
    #And the "Secret Stuff" article should be deleted
    And the "Open Stuff" article should still be in the public library

