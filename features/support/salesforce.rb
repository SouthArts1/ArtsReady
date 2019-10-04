client = SalesforceClient.new

After do |scenario|
  # disabled as app approaches EOL
  next

  errors = []

  Organization.find_each do |org|
    begin
      client.destroy_account(org)
    rescue Faraday::Error::ResourceNotFound => e
      errors << e
    end
  end

  raise errors.first if errors.any?
end