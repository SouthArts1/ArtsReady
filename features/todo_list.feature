Feature: Todo list
	In order to figure out what needs to get done
	As a user
	I want to manage my todos
	
	Scenario: A user visits the todo list page
		Given an authenticated user
		And I follow "To do"
		Then I should be on the todo list page
		And I should see "To Do List"
		