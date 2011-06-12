require 'csv'

CSV.foreach("db/questions.csv") do |row|
    Question.create(:import_id => row[0],:description => row[1], :critical_function => row[2])
end