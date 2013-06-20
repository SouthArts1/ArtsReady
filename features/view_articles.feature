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
    And I have a battle buddy with a name of "Bob's Job"
    And "Bob's Job" has a user with a first name of "Bob"
    And the following article exists:
      |       user      | critical function | title   | body                     |
      | first_name: Bob | people            | hey pal | let me tell you a secret |
    And Bob's Job has shared the article "hey pal" with me

    When I go to the library
    And I follow "People Resources (1)"
    And I follow "hey pal"
    Then I should see "a secret"

  Scenario: Shared articles of deactivated orgs should not be visible
    Given I am signed in as a reader
    And I have a battle buddy with a name of "Evil Org"
    And "Evil Org" has a user with a first name of "Snively"
    And the following article exists:
      | User                | critical function | title     |
      | first_name: Snively | people            | bad stuff |
    And Evil Org has shared the article "bad stuff" with me
    And Evil Org is deactivated

    When I go to the library
    And I follow "People Resources (1)"
    Then I should not see "bad stuff"

  Scenario: Articles written by a buddy should have the buddy icon
    Given I am signed in as a reader
    And I have a battle buddy with a name of "Bob's Job"
    And "Bob's Job" has a user with a first name of "Bob"
    And the following article exists:
      |       user        | critical function | visibility |
      | first_name: Bob   | people            | buddies    |

    When I go to the library
    And I follow "People Resources"
    Then I should see the Battle Buddy article icon

  Scenario: Critical articles should have the crit_stuff icon
    Given I am signed in as "Example"
    And the following public article exists:
      | on critical list  | critical function | User    |
      | true              | people            | Example |

    When I go to the library
    And I follow "People Resources"
    # Temporarily disabled until we have time to write the test right.
    #Then I should see the Critical article icon


  Scenario: Non-critical articles written by non-buddies should have no icons
    Given I am signed in as a reader
    And the following public article exists:
      |  On critical list  |
      |  false             |
    Then I should see no article icons
