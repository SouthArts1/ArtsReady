RSpec.configure do |c|
  c.before(:each) do
    # Stub out external services for unit tests.
    allow_any_instance_of(Organization).to receive(:geocode)
    allow_any_instance_of(Organization).to receive(:update_salesforce)
  end
end
