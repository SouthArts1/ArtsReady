class CreateNeeds < ActiveRecord::Migration
  def self.up
    create_table :needs do |t|
      t.integer :organization_id
      t.integer :crisis_id
      t.integer :user_id
      t.string :resource
      t.text :description
      t.boolean :provided
      t.string :provider
      t.date :last_updated_on

      t.timestamps
    end
    add_index :needs, :organization_id
    add_index :needs, :crisis_id
    add_index :needs, :user_id
  end

  def self.down
    drop_table :needs
  end
end