Then /^print the page$/ do
  puts body
end

Then /^where am I\?$/ do
  puts current_url
end

Then /^\{(.*)\}$/ do |ruby|
  eval ruby
end

When /^(I )?debug$/ do |who|
  debugger
  1
end
