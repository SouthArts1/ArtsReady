class CreatePaymentNotifications < ActiveRecord::Migration
  def change
    create_table :payment_notifications do |t|
      t.belongs_to :payment

      t.text :params

      t.timestamps
    end
    add_index :payment_notifications, :payment_id
  end
end
