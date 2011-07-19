Feature: Assessment
  In order to assess the readiness of my organization
  As a member
  I want to complete the readiness assessment
  
  Scenario: Create assessment
    Given a user
    And I am on the home page
    When I follow "Get Started"
    Then I should be on the new assessment page
  
  Scenario: Continue assessment
    Given a user
    And I have started an assessment
    And I am on the home page
    When I follow "Get Started"
    Then I should be on the assessment page
    
  Scenario: Finished assessment
    Given a user
    And I have finished an assessment
    And I am on the home page
    Then I should not see "Get Started"