class AddProvisionalToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :provisional, :boolean, default: false

    Subscription.where(payment_number: '0027').update_all(provisional: true)
  end
end
