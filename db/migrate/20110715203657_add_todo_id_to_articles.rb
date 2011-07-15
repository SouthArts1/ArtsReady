class AddTodoIdToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :todo_id, :integer
  end

  def self.down
    remove_column :articles, :todo_id
  end
end
