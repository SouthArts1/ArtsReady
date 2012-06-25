class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :organization_id
      t.integer :discount_code_id
      t.integer :starting_amount_in_cents
      t.integer :regular_amount_in_cents
      t.integer :arb_id
      t.string :payment_method
      t.string :payment_number
      t.integer :expiry_month
      t.integer :expiry_year
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :active
      t.string :billing_first_name
      t.string :billing_last_name
      t.string :billing_address
      t.string :billing_city
      t.string :billing_state
      t.string :billing_zipcode
      
      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
