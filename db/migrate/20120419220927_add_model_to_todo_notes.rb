class AddModelToTodoNotes < ActiveRecord::Migration
  def self.up
    add_column :todo_notes, :article_id, :integer
    add_index :todo_notes, :article_id
  end

  def self.down
    remove_column :todo_notes, :article_id
  end
end
