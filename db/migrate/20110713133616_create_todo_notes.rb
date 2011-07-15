class CreateTodoNotes < ActiveRecord::Migration
  def self.up
    create_table :todo_notes do |t|
      t.integer :todo_id
      t.integer :user_id
      t.text :message

      t.timestamps
    end
    add_index :todo_notes, :todo_id
    add_index :todo_notes, :user_id
  end

  def self.down
    drop_table :todo_notes
  end
end