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
    And I select "Start" from "todo[status]"
    And I fill in "todo[description]" with "some task"
    And I select "People Resources" from "todo[critical_function]"
    And I press "Add"
    Then I should be on the todos page
    And I should see "some task" within ".item"
    #And there should only be one item
    And I should see "successfully created" within ".flash-notice"

  Scenario: Export todos
    Given I am signed in as an editor
    And I have created the following todo items:
      | critical function | action  | description | due on      | priority | updated at     |
      | technology        | Review  | backup      | May 1, 2012 | critical | April 20, 2012 |

    When I follow "To-Do"
    And I follow "Export"
    Then I should receive the following CSV:
      | Critical Function    | Action | Description | Assigned To | Due Date   | Priority | Updated                 |
      | Technology           | Review | backup      |             | 2012-05-01 | critical | 2012-04-20 00:00:00 UTC |

