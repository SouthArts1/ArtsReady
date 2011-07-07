class OrgInCrisis < ActiveRecord::Migration
  def self.up
    add_column :organizations, :declared_crisis, :boolean, :default => false
  end

  def self.down
    remove_column :organizations, :declared_crisis
  end
end