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
		And I press "Save"
		Then I should see "created article"
		And I should see "this is a test"
		
	Scenario: User cannot set executive role
	  Given a user
	  When I go to the new article page
		Then I should not see "Executive"
	
	Scenario: Executive can set executive role
	  Given an executive
	  When I go to the new article page
		Then I should not see "Executive"
	
	Scenario: Manager can set executive role
		Given a manager
	  When I go to the new article page
		Then I should not see "Executive"
  