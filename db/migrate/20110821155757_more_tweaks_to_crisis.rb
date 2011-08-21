class MoreTweaksToCrisis < ActiveRecord::Migration
  def self.up
    add_column :crises, :description, :string
    add_column :crises, :buddy_list, :string
  end

  def self.down
    remove_column :crises, :buddy_list
    remove_column :crises, :description
  end
end