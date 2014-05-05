RSpec.configure do |c|
  c.before(:each) do
    # Stub out external geocoder service for unit tests.
    Organization.any_instance.stub(:geocode)
  end
end
