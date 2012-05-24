class ChangeDefaultCrisisVisibility < ActiveRecord::Migration
  def self.up
    change_column :crises, :visibility, :string, :default => nil
  end

  def self.down
    change_column :crises, :visibility, :string, :default => "private"
  end
end
