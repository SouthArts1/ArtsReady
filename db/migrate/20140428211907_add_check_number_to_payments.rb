class AddCheckNumberToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :check_number, :integer
  end
end
