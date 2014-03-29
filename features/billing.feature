Feature: Organization billing
  In order to continue using the site
  As an organization
  I want to manage my billing info

  Scenario: Manual renewal
    Given the date is March 19, 2024
    When I sign up and pay
    And 360 days pass
    And I update my subscription
    Then my billing info should reflect manual renewal

  Scenario: Change payment type
    Given the date is March 19, 2024
    When I sign up and pay with a checking account
    And 360 days pass
    And I change my payment method to a credit card
    Then my billing info should show payment by credit card

  Scenario: Automatic renewal
    Given the date is March 19, 2024
    When I sign up and pay
    And 367 days pass
    Then my billing info should reflect automatic renewal
