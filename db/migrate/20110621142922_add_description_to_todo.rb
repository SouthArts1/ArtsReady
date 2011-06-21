class AddDescriptionToTodo < ActiveRecord::Migration
  def self.up
    add_column :todos, :description, :string
    rename_column :todos, :note, :details
    add_column :todos, :priority, :string
  end

  def self.down
    remove_column :todos, :priority
    rename_column :todos, :details, :note
    remove_column :todos, :description
  end
end