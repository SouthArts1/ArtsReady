class CreatePaymentVariables < ActiveRecord::Migration
  def self.up
    create_table :payment_variables do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :payment_variables
  end
end
