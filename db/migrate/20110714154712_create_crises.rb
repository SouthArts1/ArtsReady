class CreateCrises < ActiveRecord::Migration
  def self.up
    create_table :crises do |t|
      t.integer :organization_id
      t.string :name
      t.text :description
      t.boolean :declared_on
      t.date :resolved_on
      t.text :resolution
      t.timestamps
    end
    add_index :crises, :organization_id
    remove_column :organizations, :declared_crisis
  end

  def self.down
    add_column :organizations, :declared_crisis, :boolean,      :default => false
    drop_table :crises
  end
end
