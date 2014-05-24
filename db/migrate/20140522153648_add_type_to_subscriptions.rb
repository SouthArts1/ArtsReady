class AddTypeToSubscriptions < ActiveRecord::Migration
  def up
    add_column :subscriptions, :type, :string

    Subscription.where(provisional: true).
      update_all("type = 'ProvisionalSubscription'")
    Subscription.where(provisional: false).
      update_all("type = 'AuthorizeNetSubscription'")
  end

  def down
    remove_column :subscriptions, :type
  end
end
