class CreateDiscounts < ActiveRecord::Migration
  def self.up
    create_table :discount_codes do |t|
      t.string :discount_code
      t.integer :deduction_value
      t.string :deduction_type
      t.integer :redemption_max
      t.datetime :active_on
      t.datetime :expires_on
      t.boolean :apply_to_first_year
      t.boolean :apply_to_post_first_year
      t.timestamps
    end
  end

  def self.down
    drop_table :discount_codes
  end
end
