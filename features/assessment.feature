Feature: Assessment
  In order to assess the readiness of my organization
  As a member
  I want to complete the readiness assessment

  Scenario: Assessment answers lead to to-do items
    Given the following questions exist:
      | critical function | description |
      | people            | counselors  |
    And the following action items exist:
      | question                | description     |
      | description: counselors | hire counselors |
    And I am signed in as an editor
    And I have started an assessment

    When I follow "Assess"
    And I follow "People Resources"
    And I answer "counselors" with "unknown/critical"
    And I follow "To-Do"
    Then I should see the following todos:
    | Action      | Item            |
    | Learn About | hire counselors |

  Scenario: I should be able to answer an assessment question
  Scenario: I should get feedback if I don't supply a complete answer
  Scenario: I should be able to skip a question
  Scenario: I should be able to reconsider a skipped question
  Scenario: I should see the people tab by default
  Scenario: I should be able to navigate the required critical functions
  Scenario: I should be able to choose the optional critical functions by default
  Scenario: I should not be able to navigate to critical functions I skipped
