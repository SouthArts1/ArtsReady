class AddBillingEmailToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :billing_email, :string
  end
end
