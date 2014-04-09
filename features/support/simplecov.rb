require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/features/'
  add_filter '/spec/'
  add_filter '/vendor/'
  add_filter '/config/'
end
