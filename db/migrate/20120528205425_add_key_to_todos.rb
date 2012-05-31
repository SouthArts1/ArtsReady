class AddKeyToTodos < ActiveRecord::Migration
  def self.up
    add_column :todos, :key, :string
  end

  def self.down
    remove_column :todos, :key
  end
end
