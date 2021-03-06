class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      
      t.integer :user_id, :organization_id
      t.string :visibility
      t.string :recipient_list
      t.text :content
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
