class FixTransactionId < ActiveRecord::Migration
  def up
    rename_column :charges, :arb_id, :transaction_id
    change_column :charges, :transaction_id, :integer, limit: 8
  end

  def down
    change_column :charges, :transaction_id, :integer, limit: 4
    rename_column :charges, :transaction_id, :arb_id
  end
end
