When /^(an?|[\d]+) (.*) pass(?:es)?$/ do |count, unit|
  Timecop.travel((count == 'a' ? 1 : count.to_i).send(unit))
end