class MoveNextBillingDateToOrganization < ActiveRecord::Migration
  def up
    add_column :organizations, :next_billing_date, :date

    # We're not bothering to copy the data over, because there basically
    # isn't any yet.

    remove_column :subscriptions, :next_billing_date
  end

  def down
    add_column :subscriptions, :next_billing_date, :date

    remove_column :organizations, :next_billing_date
  end
end
