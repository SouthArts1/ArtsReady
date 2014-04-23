class AddStateToPaymentNotifications < ActiveRecord::Migration
  def change
    add_column :payment_notifications, :state, :string, default: 'new'
    add_index :payment_notifications, :state
  end
end
