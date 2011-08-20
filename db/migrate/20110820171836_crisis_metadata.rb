class CrisisMetadata < ActiveRecord::Migration
  def self.up
    add_column :crises, :user_id, :integer
    add_index :crises, :user_id
  end

  def self.down
    remove_index :crises, :user_id
    remove_column :crises, :user_id
  end
end