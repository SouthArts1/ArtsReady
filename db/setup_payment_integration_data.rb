PaymentVariable.create({
  key: "starting_amount_in_cents",
  value: "30000"
})

PaymentVariable.create({
  key: "regular_amount_in_cents",
  value: "22500"
})

codes = [{
  discount_code: "al2012fr",
  description: "Alabama State Council for the Arts Subsidy",
  deduction_value: 100,
  deduction_type: "percentage",
  redemption_max: 5,
  apply_to_first_year: true,
  apply_to_post_first_year: false,
  active_on: Time.now,
  expires_on: Time.parse("Dec 31, 2012")
},{
  discount_code: "al2012gen",
  description: "Alabama State Council for the Arts Subsidy",
  deduction_value: 250,
  deduction_type: "dollars",
  redemption_max: 35,
  apply_to_first_year: true,
  apply_to_post_first_year: false,
  active_on: Time.now,
  expires_on: Time.parse("Dec 31, 2012")
},{
  discount_code: "ga2012gen",
  description: "Georgia Partner Subsidy",
  deduction_value: 250,
  deduction_type: "dollars",
  redemption_max: 5,
  apply_to_first_year: true,
  apply_to_post_first_year: false,
  active_on: Time.now,
  expires_on: Time.parse("Oct 31, 2012")
},{
  discount_code: "flod2012",
  description: "Flagship Organization Discount",
  deduction_value: 50,
  deduction_type: "percentage",
  redemption_max: 20,
  apply_to_first_year: true,
  apply_to_post_first_year: false,
  active_on: Time.now,
  expires_on: Time.parse("Jun 30, 2012")
},{
  discount_code: "pcla2012",
  description: "Partner Comp - LA",
  deduction_value: 100,
  deduction_type: "percentage",
  redemption_max: 1,
  apply_to_first_year: true,
  apply_to_post_first_year: true,
  active_on: Time.now,
  expires_on: Time.parse("Jun 30, 2012")
},{
  discount_code: "lapsl12",
  description: "Louisiana Partner Subsidy - Large",
  deduction_value: 200,
  deduction_type: "dollars",
  redemption_max: 20,
  apply_to_first_year: true,
  apply_to_post_first_year: false,
  active_on: Time.now,
  expires_on: Time.parse("Jun 30, 2012")
},{
  discount_code: "lapss12",
  description: "Louisiana Partner Subsidy - Small",
  deduction_value: 250,
  deduction_type: "dollars",
  redemption_max: 20,
  apply_to_first_year: true,
  apply_to_post_first_year: false,
  active_on: Time.now,
  expires_on: Time.parse("Jun 30, 2012")
},{
  discount_code: "scpss12",
  description: "South Carolina Partner Subsidy - Small",
  deduction_value: 250,
  deduction_type: "dollars",
  redemption_max: 10,
  apply_to_first_year: true,
  apply_to_post_first_year: true,
  active_on: Time.now,
  expires_on: Time.parse("Jun 30, 2012")
},{
  discount_code: "scpsl12",
  description: "South Carolina Partner Subsidy - Large",
  deduction_value: 200,
  deduction_type: "dollars",
  redemption_max: 10,
  apply_to_first_year: true,
  apply_to_post_first_year: false,
  active_on: Time.now,
  expires_on: Time.parse("Jun 30, 2012")
},{
  discount_code: "20fdpds12",
  description: "Florida Division Partner Discount - s",
  deduction_value: 250,
  deduction_type: "dollars",
  redemption_max: 10,
  apply_to_first_year: true,
  apply_to_post_first_year: true,
  active_on: Time.now,
  expires_on: Time.parse("Jun 30, 2012")
},{
  discount_code: "20fdpdl12",
  description: "Florida Division Partner Discount - l",
  deduction_value: 200,
  deduction_type: "dollars",
  redemption_max: 10,
  apply_to_first_year: true,
  apply_to_post_first_year: false,
  active_on: Time.now,
  expires_on: Time.parse("Jun 30, 2012")
},{
  discount_code: "ncpdf2012",
  description: "North Carolina Partner Discount - F",
  deduction_value: 100,
  deduction_type: "percentage",
  redemption_max: 5,
  apply_to_first_year: true,
  apply_to_post_first_year: false,
  active_on: Time.now,
  expires_on: Time.parse("Jun 30, 2012")
}]

codes.each do |c|
  DiscountCode.create(c)
end