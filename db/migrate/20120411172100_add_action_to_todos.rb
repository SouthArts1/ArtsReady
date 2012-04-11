class AddActionToTodos < ActiveRecord::Migration
  def self.up
    add_column :todos, :action, :string
  end

  def self.down
    remove_column :todos, :action
  end
end
