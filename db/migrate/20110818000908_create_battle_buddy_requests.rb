class CreateBattleBuddyRequests < ActiveRecord::Migration
  def self.up
    create_table :battle_buddy_requests do |t|
      t.integer :organization_id
      t.integer :buddy_id
      t.boolean :accepted, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :battle_buddy_requests
  end
end
