Feature: Battle Buddies
  In order to receive help in a crisis
  As an organization
  I want to find and manage battle buddies

  Scenario: Unbuddying
    Given I am signed in as an editor
      And I have a battle buddy
      When I follow "Battle Buddy Network"
    And I follow "Our Buddies"
    And I press "Remove Battle Buddy"
    Then I should be on the Our Buddies page
    And I should have no battle buddies
