class RemoveExtraTodoFields < ActiveRecord::Migration
  def self.up
    remove_column :todos, :details
    remove_column :todos, :title
  end

  def self.down
    add_column :todos, :title, :string
    add_column :todos, :details, :string
  end
end
