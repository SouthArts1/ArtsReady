RSpec.configure do |c|
  c.before(:each) do
    # Stub out external geocoder service for unit tests.
    allow_any_instance_of(Organization).to receive(:geocode)
  end
end
