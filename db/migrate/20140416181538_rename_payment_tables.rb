class RenamePaymentTables < ActiveRecord::Migration
  def up
    rename_table :payments, :subscriptions
    rename_table :charges, :payments
  end

  def down
    rename_table :payments, :charges
    rename_table :subscriptions, :payments
  end
end
