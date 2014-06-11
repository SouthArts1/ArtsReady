client = SalesforceClient.new

After do
  Organization.find_each do |org|
    client.destroy_account(org)
  end
end