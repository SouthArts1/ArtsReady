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

  Scenario: Export assessment
    Given I am signed in as an editor
    And the following questions exist:
      | critical function | description               |
      | people            | men, women, and children  |
      | finance           | remote banking            |
      | productions       | something about tickets   |
    And I have provided the following answers:
      | question                              | preparedness | priority | was skipped |
      | description: men, women, and children |        ready | critical |             |
      | description: something about tickets  |              |          |        true |

    When I follow "Assess"
    And I follow "Export"
    Then I should receive the following CSV:
      | Critical Function    | Question                 | Preparedness | Priority |
      | People Resources     | men, women, and children | ready        | critical |
      | Finances & Insurance | remote banking           |              |          |
      | Productions          | something about tickets  | N/A          | N/A      |

  Scenario: I should be able to answer an assessment question
  Scenario: I should get feedback if I don't supply a complete answer
  Scenario: I should be able to skip a question
  Scenario: I should be able to reconsider a skipped question
  Scenario: I should see the people tab by default
  Scenario: I should be able to navigate the required critical functions

  Scenario: I should be able to choose the optional critical functions by default
    Given the following question exists:
        | critical function | description |
        | productions       | happen      |
      And I am signed in as an editor

      When I follow "Assess"
      And I uncheck "We put on performances"
      And I press "Begin Assessment"
      Then all "Productions" questions should be skipped

  Scenario: Skip section
    Given the following question exists:
        | critical function | description |
        | productions       | happen      |
      And I am signed in as an editor
      And I have started an assessment with productions

      When I follow "Assess"
      And I follow "Productions"
      And I uncheck "We put on performances"
      And I press "Update Section"
      Then the assessment should be on the "Productions" tab
      And all "Productions" questions should be skipped

      # Reconsidering a question reconsiders the whole section
      When I press "reconsider"
      Then the "We put on performances" checkbox should be checked

  Scenario: Skipping a question marks the whole section skipped
    Given the following question exists:
        | critical function | description |
        | productions       | happen      |
      And I am signed in as an editor
      And I have started an assessment with productions

      When I follow "Assess"
      And I follow "Productions"
      And I press "not applicable"
      Then the "We put on performances" checkbox should not be checked

  Scenario: Re-assessment
    Given an active question exists
    And I have signed in as a manager
    And I have paid for my subscription
    And I have started an assessment with facilities
    When a week passes
    And I finish the assessment
    And 340 days pass
    And the scheduled tasks have run
    And I have renewed my subscription
    Then I should have a re-assessment to-do
    
    When I initiate a re-assessment
    Then the "We have our own space/facility" checkbox should be checked
    
    When I start the re-assessment
    Then I should have 1 archived assessment
    And I should be able to view the archived assessment
    
    When I finish the re-assessment
    And I complete the "repeating your assessment" todo
    And 340 days pass
    And the scheduled tasks have run
    Then I should have another re-assessment to-do

    # Add another question, so we can "partially complete" an assessment
    Given an active question exists
    When I have a partially completed assessment
    And I can re-assess without completing the previous assessment