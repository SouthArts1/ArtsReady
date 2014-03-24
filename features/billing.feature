Feature: Organization billing
  In order to continue using the site
  As an organization
  I want to manage my billing info

  Scenario: Automatic renewal
    Given the date is March 19, 2024
    When I sign up and pay
    And 367 days pass
    Then my billing info should reflect automatic renewal
