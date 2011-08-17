class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.text :comment
      t.integer :user_id, :article_id
      t.boolean :disabled, :default => false
      t.timestamps
    end

    add_index :comments, :user_id
    add_index :comments, :article_id
  end

  def self.down
    drop_table :comments
  end
end
