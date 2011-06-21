class AddBbFlagToOrg < ActiveRecord::Migration
  def self.up
    add_column :organizations, :battle_buddy_enabled, :boolean, :default => false
  end

  def self.down
    remove_column :organizations, :battle_buddy_enabled
  end
end