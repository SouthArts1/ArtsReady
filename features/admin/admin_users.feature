Feature: Admin user management
  In order to improve and assess usage
  As an admin
  I want to manage the user list

  Scenario: List users
    Given the date is March 28, 2024
    And the following sysadmin exists:
      | Organization | Email             |
      | Name: MyOrg  | admin@example.org |
    And the following paid user exists:
      | Email               |
      | csvuser@example.com |
    And I am signed in as "admin@example.org"
    When I follow "Download User Report"
    Then I should receive the following CSV:
      | User First Name | User Last Name | User Email          | Account Name      | Physical Address | Physical Address 2 | City     | State | Zip Code | Phone Number | Fax Number | Parent Organization | Subsidizing Organization | Organizational Status (2 digits) | National Standard Institution Code | Other NSI Code | Primary Contact Name | Primary Contact Email | Billing First Name | Billing Last Name | Billing Address | Billing City | Billing State | Billing Zip Code | Billing Phone Number | Billing Email             | Discount Code | Payment Type | Ends in | First Billing Date | First Billing Amount | Next Billing Date Occurs in (Days) | Next Billing Amount | Account Expiration Date |
      | First           | Last           | admin@example.org   | MyOrg             | 100 Test St      |                    | New York | NY    | 10001    |              |            |                     |                          | test                             |                                    |                |                      |                       |                    |                   |                 |              |               |                  |                      |                           |               |              |         |                    |                      |                                    |                     |                         |
      | First           | Last           | csvuser@example.com | Paid Organization | 100 Test St      |                    | New York | NY    | 10001    |              |            |                     |                          | test                             |                                    |                |                      |                       | Bill               | Lastname          | 100 Test St     | New York     | NY            | 10001            | 555-555-1212         | bill_lastname@example.com |               | Credit Card  | 0027    | 03/29/2024         | $1.00                | 1                                  | $1.00               | 1/2027                  |
