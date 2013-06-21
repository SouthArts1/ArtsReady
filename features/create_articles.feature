Feature: Create articles
  In order to share information on the site
  As a user
  I want to create and manage articles

	Scenario: User adds an article
	  Given a user
	  When I go to the new article page
		And I fill in "article[title]" with "this is a test"
		And I fill in "article[description]" with "this is only a test"
		And I fill in "article[body]" with "this is not an actual emergency"
		And I select "People" from "article[critical_function]"
		And I press "Save"
		Then I should see "created article"
		And I should see "this is a test"
	
  Scenario: User adds an article from the to-do page
    Given a user
    And I have created a todo item
    When I add an article titled "This is an article" to the todo item
    Then I should be on the todo item

    When I follow "This is an article" within the log
    Then I should be on the article page

  Scenario: User can't share article with deactivated orgs
    Given an editor
    And I have a Battle Buddy with a name of "GoodOrg"
    And I have a Battle Buddy with a name of "BadOrg"
    And BadOrg is deactivated
	  When I go to the new article page
    And I choose "article_visibility_shared"
    Then I should see "GoodOrg"
    And I should not see "BadOrg"

	#TODO most of these should probably be view tests	
	Scenario: User cannot set executive visibility
	  Given a user
	  When I go to the new article page
		Then I should not see "Executive"
	
	Scenario: Editor cannot set executive visibility
	  Given an editor
	  When I go to the new article page
		Then I should not see "Executive" within "#organization"

	Scenario: Manager can set executive visibility
		Given a manager
	  When I go to the new article page
		Then I should see "Executive" within "#organization"

	Scenario: Executive can set executive visibility
	  Given an executive
	  When I go to the new article page
		Then I should see "Executive" within "#organization"

	Scenario: User cannot set battle buddy visibility
	  Given a user
	  When I go to the new article page
		Then I should not see "All Battle Buddies"
		And I should not see "#battle-buddies"
		
	Scenario: Editor can set battle buddy visibility
	  Given an editor
	  When I go to the new article page
		Then I should see "All Battle Buddies" within "#battle-buddies"

	Scenario: Manager can set battle buddy visibility
		Given a manager
	  When I go to the new article page
		Then I should see "All Battle Buddies" within "#battle-buddies"

	Scenario: Executive can set battle buddy visibility
	  Given an executive
	  When I go to the new article page
		Then I should see "All Battle Buddies" within "#battle-buddies"
