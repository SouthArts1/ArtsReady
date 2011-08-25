class AddLastUserForTodoNote < ActiveRecord::Migration
  def self.up
    add_column :todos, :last_user_id, :integer
  end

  def self.down
    remove_column :todos, :last_user_id
  end
end