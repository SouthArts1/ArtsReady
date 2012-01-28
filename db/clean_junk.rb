list = [3,4,5,15,16,17,19,21,22,23,24,27,29,30]

list.each do |i|
  o=Organization.find(i)
  puts "destroying #{o.name}"
  o.destroy if o.present?
end

o=Organization.find(1)
o.assessment.destroy