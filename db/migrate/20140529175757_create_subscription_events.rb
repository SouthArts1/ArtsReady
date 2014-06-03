class CreateSubscriptionEvents < ActiveRecord::Migration
  def up
    create_table :subscription_events do |t|
      t.text :notes
      t.belongs_to :organization
      t.datetime :happened_at

      t.timestamps
    end
    add_index :subscription_events, :organization_id

    add_column :payments, :subscription_event_id, :integer
    add_index :payments, :subscription_event_id

    Payment.find_each do |payment|
      SubscriptionEvent.create(
        notes: payment.notes,
        organization_id: payment.organization_id,
        happened_at: payment.paid_at,
        payment: payment
      )
    end

    remove_columns :payments, :notes, :organization_id, :paid_at
  end

  def down
    add_column :payments, :notes, :text
    add_column :payments, :paid_at, :datetime
    add_column :payments, :organization_id, :integer
    add_index :payments, :organization_id

    SubscriptionEvent.includes(:payment).find_each do |event|
      if event.payment
        event.payment.update_columns(
          notes: event.notes,
          paid_at: event.paid_at,
          organization_id: event.organization_id
        )
      end
    end

    remove_column :payments, :subscription_event_id

    drop_table :subscription_events
  end
end
