require 'CSV'
#CSV.parse(questions) do |row|
#Action Item,RAQ id,Critical Function,Recurrence

CSV.foreach('db/action_items.csv') do |row|
  puts row.inspect
  q = Question.find_by_import_id(row[1])
  q.action_items.create(:description => row[0], :import_id => row[1], :recurrence => row[3])
end