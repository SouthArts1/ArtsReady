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
     | NSI Code         | 33                |
    And I select "02 Organization - Non-profit" from "organization_organizational_status"
    And I check "terms"
    And I press "Create Organization"
    Then I should be on the new billing page

    When I fill out and submit the billing form
    Then I should be on the dashboard
    And my billing info should be saved

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

  @javascript
  Scenario: Sign up with discount code
    Given a 50% discount code exists
    When I sign up using the discount code
    Then I should be signed in

  Scenario: Sign up with invalid billing data
    When I sign up and pay with invalid billing data
    Then the billing form is rejected

# When we upgraded to Capybara 2.1 and Poltergeist 1.5.0, the "should be
# signed in" step seemingly stopped waiting for the new page to load, and
# started failing intermittently.
#
# In the long run, this isn't a feature we want, but we are temporarily
# using it to support a "two years free" discount code. So we should try
# to get this test working again. Maybe Capybara 2.2 magically fixes it.
#
#  @javascript
#  Scenario: Sign up with a 100% discount code
#    Given a 100% discount code exists
#    When I sign up using the discount code
#    Then I should be signed in
