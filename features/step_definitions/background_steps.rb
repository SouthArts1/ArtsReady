When /^the background jobs have run$/ do
  Delayed::Worker.new.work_off
end
