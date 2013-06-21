Feature: Dashboard
	In order to manage my emergency planning
	As a user
  I want to manage my organization from my dashboard

  Background:
		Given a user
	
	Scenario: On the dashboard
		And I am on the dashboard page
		Then I should see urgent to dos area

  Scenario: Featured articles on the dashboard
    And a featured article exists with a title of "Dashboard featured article"
    When I go to the dashboard page
    Then I should see "Dashboard featured article"

  Scenario: Featured articles by deactivated orgs on the dashboard
    And a featured article exists with a title of "Deactivated org's article"
    And that article's organization has been deactivated
    When I go to the dashboard page
    Then I should not see "Deactivated org's article"

  Scenario: Active crises on the dashboard
    And there is an active crisis with description "Urgent!"
    When I go to the dashboard page
    Then I should see "Urgent!"

  Scenario: Active crises of deactivated orgs on the dashboard
    And there is an active crisis with description "Nefarious needs"
    And that crisis' organization has been deactivated
    When I go to the dashboard page
    Then I should not see "Nefarious needs"

	@todo
	Scenario: See urgent To-Dos
		Given a user with an urgent to do
		And I am on the dashboard page
		# Then I should see "Due" within ".urgent"
