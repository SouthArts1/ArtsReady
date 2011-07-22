Feature: Dashboard
	In order to manage my emergency planning
	As a user
	I want to manage my organization from my dashboard
	
	Scenario: On the dashboard
		Given a user
		And I am on the dashboard page
		Then I should see urgent to dos area

	@todo
	Scenario: See urgent To-Dos
		Given a user with an urgent to do
		And I am on the dashboard page
		# Then I should see "todo"
