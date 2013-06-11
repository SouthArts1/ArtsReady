Feature: Inactive users
  As an inactive user
  I am free from both the pleasures and the responsibilities
    of membership

  Background:
    Given the following user exists:
      |         email        | password |
      | inactive@email.com |   pass   |

  Scenario: An inactive user cannot sign in
    When I am disbarred
    Then I cannot sign in
