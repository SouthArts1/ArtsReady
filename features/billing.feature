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

  Scenario: Change payment type
    Given the date is March 19, 2024
    When I sign up and pay with a checking account
    And 360 days pass
    And I change my payment method to a credit card
    Then my billing info should show payment by credit card

  Scenario: Cancel subscription
    Given the date is March 19, 2024
    When I sign up and pay
    And 350 days pass
    And I cancel my subscription

    When I sign out
    And the scheduled tasks have run
    Then I can't sign in

  Scenario: Automatic renewal
    Given the date is March 19, 2024
    And a renewal receipt template exists
    When I sign up and pay
    And 367 days pass
    And I have renewed automatically
    Then my billing info should reflect automatic renewal
    And I should receive a renewal receipt

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
    And my credit card expires in 30 days
    When the scheduled tasks have run
    Then I should receive a credit card expiration notice
