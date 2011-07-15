class CreateUpdates < ActiveRecord::Migration
  def self.up
    create_table :updates do |t|
      t.string :title
      t.text :message
      t.integer :user_id
      t.integer :crisis_id
      t.integer :organization_id

      t.timestamps
    end
    add_index :updates, :user_id
    add_index :updates, :crisis_id
    add_index :updates, :organization_id
  end

  def self.down
    drop_table :updates
  end
end