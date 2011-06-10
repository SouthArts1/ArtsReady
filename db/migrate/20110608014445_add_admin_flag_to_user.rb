class AddAdminFlagToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :admin, :boolean, :default => false
    add_column :organizations, :active, :boolean, :default => false
  end

  def self.down
    remove_column :organizations, :active
    remove_column :users, :admin
  end
end