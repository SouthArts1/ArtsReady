class MoreTodoFields < ActiveRecord::Migration
  def self.up
    add_column :todos, :review_on, :date
    add_column :todos, :title, :string
    add_column :todos, :critical_function, :string
  end

  def self.down
#    remove_column :todos, :critical_function
    remove_column :todos, :title
    remove_column :todos, :review_on
  end
end