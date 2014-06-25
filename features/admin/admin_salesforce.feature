Feature: Salesforce integration
  In order to manage customer relationships
  As an admin
  I want customer data imported into Salesforce

Scenario: Add new organization to Salesforce
  Given the date is "June 24, 2014"
  When an organization signs up and pays
  Then the organization should be added to Salesforce
  When the organization is updated
  Then Salesforce should be updated
  When the organization's billing info is updated
  Then Salesforce billing info should be updated
  When the organization is charged
  Then Salesforce payment info should be updated
