Feature: Salesforce integration
  In order to manage customer relationships
  As an admin
  I want customer data imported into Salesforce

Scenario: Add new organization to Salesforce
  When an organization signs up
  Then the organization should be added to Salesforce
