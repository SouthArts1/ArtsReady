Feature: Battle Buddies
  In order to receive help in a crisis
  As an organization
  I want to find and manage battle buddies

  Scenario: Finding Buddies
    Given I am signed in as an editor
    And an organization exists with a name of "Another Org"
    When I follow "Battle Buddy Network"
    And I follow "Find a Buddy"
    And I follow "Another Org"
    And I press "Add as Battle Buddy"
    And I follow "Find a Buddy"
    Then I should see "SENT"

  Scenario: Rejecting Buddies
    Given I am signed in as an editor
    And I have a pending battle buddy request
    When I follow "Battle Buddy Network"
    And I follow "Find a Buddy"
    And I press "Decline"
    Then I should have no pending battle buddy requests

  Scenario: Unbuddying
    Given I am signed in as an editor
      And I have a battle buddy
      When I follow "Battle Buddy Network"
      # Temporarily disabled until Our Buddies page is ready.
    #And I follow "Our Buddies"
    #And I press "Remove Battle Buddy"
    #Then I should be on the Our Buddies page
    #And I should have no battle buddies

  Scenario: Remove buddy via profile page
    Given I am signed in as an editor
    And I have a battle buddy with a name of "My Buddy"
    When I follow "Battle Buddy Network"
    And I follow "Find a Buddy"
    And I follow "My Buddy"
    #And I debug
    And I press "Remove Battle Buddy"
    Then I should see "removed"

