class AddDescriptionToTodo < ActiveRecord::Migration
  def self.up
    add_column :todos, :description, :string
    rename_column :todos, :note, :details
  end

  def self.down
    rename_column :todos, :details, :note
    remove_column :todos, :description
  end
end