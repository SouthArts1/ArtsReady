class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.belongs_to :organization
      t.belongs_to :subscription
      t.belongs_to :discount_code

      t.datetime :paid_at
      t.integer :amount_in_cents
      t.integer :arb_id
      t.string :payment_method
      t.string :routing_number
      t.string :account_number
      t.string :account_type

      t.timestamps
    end
  end
end
