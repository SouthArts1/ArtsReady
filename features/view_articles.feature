Feature: View articles
  In order to learn things from the site
  As a user
  I want to see the articles

  Background:
    Given a user
    
  Scenario: Public articles should be visible
    Given a public article exists with a title of "Public article"
    When I go to the articles page
    Then I should see "Public article"
  
  Scenario: Private articles should not be visible
    Given a private article exists with a title of "Private article"
    When I go to the articles page
    Then I should not see "Private article"

  Scenario: Disabled articles should not be visible
    Given a disabled article exists with a title of "Disabled article"
    When I go to the articles page
    Then I should not see "Disabled article"

  Scenario: View an article shared by a buddy
    Given I am signed in as a reader
    And I have a battle buddy with a name of "Bob"
    And Bob has shared the following article with me:
      | critical function | title   | body                     |
      | people            | hey pal | let me tell you a secret |
    
    When I go to the library
    And I follow "People Resources (1)"
    And I follow "hey pal"
    Then I should see "a secret"
    
  Scenario: Articles written by a buddy should have the buddy icon
    Given I am signed in as a reader
    And I have a battle buddy with a name of "Bob"
    And the following public article exists:
      | organization  | critical function |
      |   name: Bob   | people            |

    When I go to the "people" articles page
    Then I should see the Battle Buddy article icon

  Scenario: Critical articles should have the crit_stuff icon
    Given I am signed in as a reader
    And the following public article exists:
      | on critical list  | critical function |
      | true              | people            |

    When I go to the "people" articles page
    Then I should see the Critical article icon


  Scenario: Non-critical articles written by non-buddies should have no icons
    Given I am signed in as a reader
    And the following public article exists:
      |  On critical list  |
      |  false             |
    Then I should see no article icons
