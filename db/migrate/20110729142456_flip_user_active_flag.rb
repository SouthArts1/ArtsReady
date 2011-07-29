class FlipUserActiveFlag < ActiveRecord::Migration
  def self.up
    rename_column :users, :active, :disabled
  end

  def self.down
    rename_column :users, :disabled, :active
  end
end