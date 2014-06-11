# THIS FILE MUST BE LOADED FIRST or at least early, so that the
# VCR cassette is ejected *after* any other After hooks run. This
# way, VCR will still be recording while the After hooks run, in
# case they send any HTTP requests.

require 'webmock/cucumber'

VCR.configure do |c|
  c.cassette_library_dir = 'features/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.ignore_localhost = true
end

# We'd like to use an Around block, but the background steps are executed
# before our Around block starts, so if they attempt to use HTTP, VCR
# flags it. Supposedly this was fixed in Cucumber, but it's still failing
# for us even after an upgrade. Anyway, for now we use Before and After.
Before do |scenario|
  VCR.insert_cassette [
    scenario.feature, scenario
  ].map { |component| component.title.parameterize }.join('/') #,
    # record: :new_episodes
end

After do
  VCR.eject_cassette
end

# Around do |scenario, block|
#   VCR.use_cassette('default') do
#     block.call
#   end
# end