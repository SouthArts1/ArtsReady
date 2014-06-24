require 'spec_helper'

describe SalesforceClient do
  subject(:client) { SalesforceClient.new }

  let(:external_id_field) { 'ArtsReady_ID__c' }
  let(:salesforce_id) { 'lsdkjhsrubsrfd' }
  let(:sobject) { double('Restforce SObject', Id: salesforce_id) }
  let(:restforce) {
    double('Restforce client',
      upsert!: true,
      find: sobject,
      destroy: true
    )
  }

  before { Restforce.stub(:new).and_return(restforce) }

  describe 'new' do
    it 'builds a Restforce client' do
      expect(client.restforce).to eq(restforce)
    end
  end

  describe 'upsert_account(organization)' do
    let(:organization) {
      FactoryGirl.build_stubbed(:organization,
        name: 'Salesforce Org'
      )
    }

    it 'upserts the account for the organization' do
      organization.stub(
        billing_address: '100 N Test St.',
        discount_code_identifier: 'DISCO'
      )

      client.upsert_account(organization)

      expect(restforce).to have_received(:upsert!) do |table, id_field, fields|
        expect(table).to eq 'Account'
        expect(id_field).to eq external_id_field
        expect(fields[external_id_field]).to eq organization.id

        # We don't want to list every field and its value here, so we
        # loop over the ones we care about instead of just comparing two
        # hashes.
        {
          Name: 'Salesforce Org',
          Discount_Code__c: 'DISCO',
          BillingStreet: '100 N Test St.'
        }.each do |field, value|
          expect(fields[field]).to eq(value)
        end
      end
    end
  end

  describe 'find_account(organization)' do
    let(:organization) {
      FactoryGirl.build_stubbed(:organization)
    }

    it 'finds the account for the organization' do
      expect(client.find_account(organization)).to eq(sobject)

      expect(restforce).to have_received(:find).with(
        'Account', organization.id, external_id_field
      )
    end
  end

  describe 'destroy_account(organization)' do
    let(:organization) {
      FactoryGirl.build_stubbed(:organization)
    }

    it 'destroys the account for the organization' do
      client.destroy_account(organization)

      expect(restforce).to have_received(:destroy).with(
        'Account', salesforce_id
      )
    end
  end
end
