class AddCompleteToTodos < ActiveRecord::Migration
  def self.up
    add_column :todos, :complete, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :todos, :complete
  end
end
