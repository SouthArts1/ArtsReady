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

  # If we just say 'debugger', the debugger ends up in some weird
  # context. So we do something after the debugger line.
  1
end

