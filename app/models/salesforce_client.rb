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
    fields = account_fields(organization)

    restforce.upsert!('Account', EXTERNAL_ID_FIELD, fields)
  rescue Faraday::Error::ClientError => e
    # Airbrake helpfully removes the `ArtsReady_ID__c` parameter, so we
    # duplicate it as `id`.
    Airbrake.notify_or_ignore(e, parameters: fields.merge(id: organization.id))
    false
  end

  def account_fields(organization)
    {
      ArtsReady_ID__c:               organization.id,
      Name:                          organization.name,
      Phone:                         organization.phone_number,
      Fax:                           organization.fax_number,
      # Subsidizing_Organization__c:   organization.subsidizing_organization,
      Parent_Organization__c:        organization.parent_organization,
      Operating_Budget__c:           organization.operating_budget,
      Physical_Address__c:           organization.address,
      Physical__c:                   organization.city,
      Physical_State__c:             organization.state,
      Physical_Postal_Code__c:       organization.zipcode,
      Primary_Contact_First_Name__c: organization.contact_first_name,
      Primary_Contact_Last_Name__c:  organization.contact_last_name,
      Primary_Contact_Email__c:      organization.email,
      Billing_First_Name__c:         organization.billing_first_name,
      Billing_Last_Name__c:          organization.billing_last_name,
      BillingStreet:                 organization.billing_address,
      BillingCity:                   organization.billing_city,
      BillingState:                  organization.billing_state,
      BillingPostalCode:             organization.billing_zipcode,
      Payment_Type__c:               organization.payment_method,
      Ends_in__c:                    organization.payment_number,
      Discount_code__c:              organization.discount_code_identifier,
      First_Billing_Date__c:         organization.first_billing_date,
      First_Billing_Amount__c:       organization.first_billing_amount,
      Amount_Paid__c:                organization.latest_billing_amount,
      Next_Billing_Date__c:          organization.next_billing_date,
      Next_Billing_Amount__c:        organization.next_billing_amount
    }
  end

  def find_account(organization)
    restforce.find('Account', organization.id, EXTERNAL_ID_FIELD)
  end

  def destroy_account(organization)
    restforce.destroy('Account', find_account(organization).Id)
  end
end