class MoreCrisisTweaks < ActiveRecord::Migration
  def self.up
    add_column :crises, :visibility, :string, :default => 'private'
    remove_column :crises, :name
    remove_column :crises, :description
    remove_column :crises, :declared_on
  end

  def self.down
    add_column :crises, :declared_on, :boolean
    add_column :crises, :description, :string
    add_column :crises, :name, :string
    remove_column :crises, :visibility
  end
end
