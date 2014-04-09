class AddBillingPhoneNumberToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :billing_phone_number, :string
  end
end
