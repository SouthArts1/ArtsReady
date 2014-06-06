Feature: Organization billing
  In order to continue using the site
  As an organization
  I want to manage my billing info

  Scenario: Switch from provisional to paid
    Given I have provisional access
    Then I can switch to paid access

  Scenario: Manual renewal
    Given the date is March 19, 2024
    When I sign up and pay
    And 360 days pass
    And I update my subscription
    Then my billing info should reflect manual renewal

  Scenario: Billing update rejected by payment gateway
    When I sign up and pay
    And I update my subscription and am rejected by the payment gateway
    Then the billing form is rejected
    And admins should receive a failed payment form notification

  Scenario: Change payment type
    Given the date is March 19, 2024
    When I sign up and pay with a checking account
    And 360 days pass
    And I change my payment method to a credit card
    Then my billing info should show payment by credit card

  Scenario: Cancel subscription and revive it
    Given the date is March 19, 2024
    When I sign up and pay
    And I have been charged automatically
    And 350 days pass
    And I cancel my subscription

    Then I should be signed out
    And I can't sign in

    But I can revive my cancelled subscription
    # Before the initial expiration date, so we start a new
    # ARB subscription on the renewal date.
    And my next billing date should be March 20, 2025

  Scenario: Automatic renewal
    Given the date is March 19, 2024
    When I sign up and pay
    And 367 days pass
    And I have renewed automatically
    Then my billing info should reflect automatic renewal

  Scenario: Renewal reminders
    Given a renewal reminder template exists
    When I sign up and pay
    And a day passes
    And I have been charged automatically
    And 335 days pass
    And the scheduled tasks have run
    Then I should receive a 30-day renewal reminder
    When 15 days pass
    And the scheduled tasks have run
    Then I should receive a 15-day renewal reminder

  Scenario: Credit card expiration notice
    Given a credit card expiration template exists
    And my credit card expires at the end of this month
    And I have been charged automatically
    When the scheduled tasks have run
    Then I should receive a credit card expiration notice
