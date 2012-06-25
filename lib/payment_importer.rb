require 'csv'

#row: [organization, expiration, note, email, primary user, annual price]
i = 1
CSV.parse(File.open("#{Rails.root}/lib/sign_up_dates.csv", 'rb')) do |row|
  if (i > 10) 
    u = User.find_by_email(row[3])
    o = Organization.find_by_name(row[0])
    
    if !u
      if o
        u = o.users.first
      else 
        puts "No org or user found"
      end
    end
    
    if u && !o
      o = u.organization
    end
    
    if u && o
      puts "Creating for #{o.name} with #{u.first_name} #{u.last_name}"
      amount = row[5].to_i * 100 
      
      p = Payment.create({
        organization_id: o.id,
        starting_amount_in_cents: amount,
        regular_amount_in_cents: amount,
        start_date: (Date.strptime(row[1], "%m/%d/%Y") + 1.year),
        active: 1,
        billing_first_name: u.first_name,
        billing_last_name: u.last_name,
        billing_address: o.address,
        billing_city: o.city,
        billing_state: o.state,
        billing_zipcode: o.zipcode,
        account_number: "000015990049",
        routing_number: "051404260",
        bank_name: "BBT",
        account_type: "checking",
        payment_type: 'bank'
      })
      puts "Roll on ***\n #{p.inspect}"
      p.reload
      puts "Payment created: #{p.id} ARB: #{p.arb_id}"
    end
  end
  i = i + 1
end