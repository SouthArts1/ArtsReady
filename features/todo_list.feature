Feature: Todo list
  In order to track tasks
  As a user
  I want to manage tasks in a todo list

  Scenario: The todo list starts blank
    Given a user
    When I go to the todos page
    Then I should not see any todos
    
  Scenario: The people tab is the default

  Scenario: A user adds a todo
    Given a user
    When I go to the todos page
    And I select "Start" from "todo[action]"
    And I fill in "todo[description]" with "some task"
    And I select "People Resources" from "todo[critical_function]"
    And I press "Add"
    Then I should be on the todos page
    And I should see "some task" within ".item"
    And I should see "Start" within ".action"
    #And there should only be one item
    And I should see "successfully created" within ".flash-notice"

  Scenario: A user adds a todo from the assessment
    Given a user
    And I have started an assessment
    When I go to the assessment page
    And I select "Start" from "todo[action]"
    And I fill in "todo[description]" with "some task"
    And I select "People Resources" from "todo[critical_function]"
    And I press "Add"
    And I go to the todos page
    Then I should see "some task" within ".item"
    And I should see "Start" within ".action"

  Scenario: A user is reminded about overdue todos
    Given I am signed in as a paid reader
    And I have an overdue todo item
    Then I should receive todo reminders on Tuesdays

    When I complete the overdue todo item
    Then I should not receive todo reminders

  Scenario: Add a todo from a re-assessment
    Given a question exists with a description of "org chart"
    And the following action item exists:
      | description | question               |
      | org chart   | description: org chart |
    And I am signed in as an editor
    And I have finished an assessment
    And I have completed the "org chart" todo

    When 6 months pass
    And I start a re-assessment
    And I answer the "org chart" question
    Then the "org chart" todo should be restarted
    And the "org chart" todo's history should be preserved

  Scenario: Export todos
    Given I am signed in as an editor
    And I have created the following todo items:
      | critical function | action   | description | due on      | priority     | complete |
      | finance           | Work On  | budget      | May 1, 2012 | non-critical | true     |
      | technology        | Review   | backup      | May 1, 2012 | critical     | false    |

    When I follow "To-Do"
    And I follow "Export"
    Then I should receive the following CSV:
      | Critical Function    | Action | Description | Assigned To | Due Date   | Priority     |
      | Finances & Insurance | Done   | budget      |             | 2012-05-01 | non-critical |
      | Technology           | Review | backup      |             | 2012-05-01 | critical     |

