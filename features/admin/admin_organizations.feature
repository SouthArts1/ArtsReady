Feature: Admin organization management
  In order to improve and assess usage
  As an admin
  I want to manage the organization list

  Scenario: List organizations
    Given 2 questions exist
    Given the following organization exists:
      | Name  | Member Count | Completed Answers Count | To Do Usage |
      | MyOrg | 1            | 1                       | 1/2         |
    And the following sysadmin exists:
      | Organization | Email             |
      | Name: MyOrg  | admin@example.org |
    And I am signed in as "admin@example.org"

    When I follow "Manage Organizations"
    Then I should see the following organizations:
      | Name  | Members   | Assessment % | To-Do % |
      | MyOrg | 2 members | 50%          | 50%     |
      # 2 members including the admin

    When I follow "2 members"
    Then I should see "Last Login"

  Scenario: Delete organization
    Given the following organization exists:
      | Name   | Active |
      | MyOrg  | false  |
    And all users for "MyOrg" are disabled
    # This is a really wordy workaround for the fact that the article
    # factory has a user, but not an organization anymore.
    And the following articles exist:
      | organization_id | Title        | Visibility |
      | #{Organization.find_by_name("MyOrg").id} | Secret Stuff | executive  |
      | #{Organization.find_by_name("MyOrg").id} | Open Stuff   | public     |
      | #{Organization.find_by_name("MyOrg").id} | Shared Stuff | buddies    |
    And I am signed in as a sysadmin

    When I delete the organization "MyOrg"
    Then the organization "MyOrg" should be deleted
    #And the "Secret Stuff" article should be deleted
    And the "Open Stuff" article should still be in the public library

  Scenario: Organization status
    Given organizations with the following states:
      | Name          | Active | Subscription | Past Due? |
      | New Org       | false  | none         |           |
      | Cancelled Org | false  | inactive     |           |
      | Disabled Org  | false  | active       |           |
      | Temporary Org | true   | none         |           |
      | Active Org    | true   | active       |           |
      | Lapsed Org    | true   | active       | true      |
    And I am signed in as a sysadmin

    When I follow "Manage Organizations"
    Then I should see the following organization statuses:
      | Name          | Status               |
      | New Org       | new                  |
      | Cancelled Org | cancelled            |
      | Disabled Org  | disabled             |
      | Temporary Org | temporarily approved |
      | Active Org    | active               |
      | Lapsed Org    | past due             |
