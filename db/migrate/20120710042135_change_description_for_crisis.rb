class ChangeDescriptionForCrisis < ActiveRecord::Migration
  def self.up
    change_column :crises, :description, :text
  end

  def self.down
    change_column :crises, :description, :string
  end
end
