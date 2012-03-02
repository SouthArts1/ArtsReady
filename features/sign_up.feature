Feature: New organization registration
  In order to become a member
  As a visitor  
  I want to register with the site
  
  Scenario: A visitor registers their organization
    When I am on the sign up page
    And I fill in the following:
     | Name             | My Org            |
     | Address          | 100 Test St       |
     | City             | New York          |
     | State            | NY                |
     | Zipcode          | 10001             |
     | First Name       | New               |
     | Last Name        | User              |
     | Email            | newuser@test.host |
     | Password         | password          |
     | Confirm Password | password          |
    And I select "02 Organization - Non-profit" from "organization_organizational_status"
    And I select "Less than $1,000,000" from "organization_operating_budget"
    And I check "terms"
    And I press "Create Organization"
    Then I should be on the welcome page
    
  Scenario: A visitor tries to sign up without entering any information
    When I go to the sign up page
    And I press "Create Organization"
    Then I should see error messages

  Scenario: A visitor tries to sign up with partial information
    When I go to the sign up page
    And I fill in the following:
     | Name             | My Org            |
     | Email            | newuser@test.host |
     | Password         | password          |
     | Confirm Password | password          |
    And I press "Create Organization"
    Then I should see error messages
