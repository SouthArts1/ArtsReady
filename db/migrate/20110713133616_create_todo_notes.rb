class CreateTodoNotes < ActiveRecord::Migration
  def self.up
    create_table :todo_notes do |t|
      t.integer :todo_id
      t.integer :user_id
      t.text :message

      t.timestamps
    end
  end

  def self.down
    drop_table :todo_notes
  end
end
