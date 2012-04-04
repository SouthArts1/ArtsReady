Feature: Admin organization management
  In order to improve and assess usage
  As an admin
  I want to manage the organization list

  Scenario: List organizations
    Given the following organization exists:
      | Name  | Member Count | Assessment Usage | To Do Usage |
      | MyOrg | 1            | 1/2              | 1/2         |
    And the following sysadmin exists:
      | Organization | Email             |
      | Name: MyOrg  | admin@example.org |
    And I am signed in as "admin@example.org"

    When I follow "Manage Organizations"
    Then I should see the following organizations:
      | Name  | Members   | Assessment % | To-Do % |
      | MyOrg | 2 members | 50%          | 50%     |
      # 2 members including the admin

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

    When I delete the organization "MyOrg"
    Then the organization "MyOrg" should be deleted
    #And the "Secret Stuff" article should be deleted
    And the "Open Stuff" article should still be in the public library

