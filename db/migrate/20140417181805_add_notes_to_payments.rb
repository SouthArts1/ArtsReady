class AddNotesToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :notes, :text
  end
end
