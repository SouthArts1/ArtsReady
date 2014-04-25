class AddNextBillingDateToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :next_billing_date, :date
  end
end
