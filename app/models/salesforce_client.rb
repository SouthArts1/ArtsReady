class SalesforceClient
  cattr_accessor :host, :username, :password,
    :client_id, :client_secret, :security_token

  attr_accessor :restforce

  EXTERNAL_ID_FIELD = 'ArtsReady_ID__c'

  def initialize
    self.restforce = Restforce.new(
      host: SalesforceClient.host,
      username: SalesforceClient.username,
      password: SalesforceClient.password,
      client_id: SalesforceClient.client_id,
      client_secret: SalesforceClient.client_secret,
      security_token: SalesforceClient.security_token
    )
  end

  def upsert_account(organization)
    fields = {
      ArtsReady_ID__c:   organization.id,
      Name:              organization.name,
      Phone:             organization.phone_number,
      Fax:               organization.fax_number,
      Subsidizing_Organization__c: organization.subsidizing_organization,
      Parent_Organization__c: organization.parent_organization,
      Operating_Budget__c: organization.operating_budget,
      Physical_Address__c: organization.address,
      Physical__c: organization.city,
      Physical_State__c: organization.state,
      Physical_Postal_Code__c: organization.zipcode,
      BillingStreet:     organization.billing_address,
      BillingCity:       organization.billing_city,
      BillingState:      organization.billing_state,
      BillingPostalCode: organization.billing_zipcode
    }

    restforce.upsert!('Account', EXTERNAL_ID_FIELD, fields)
  rescue Faraday::Error::ClientError => e
    # Airbrake helpfully removes the `ArtsReady_ID__c` parameter, so we
    # duplicate it as `id`.
    Airbrake.notify_or_ignore(e, parameters: fields.merge(id: organization.id))
    false
  end

  def find_account(organization)
    restforce.find('Account', organization.id, EXTERNAL_ID_FIELD)
  end

  def destroy_account(organization)
    restforce.destroy('Account', find_account(organization).Id)
  end
end