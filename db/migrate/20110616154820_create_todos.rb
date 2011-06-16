class CreateTodos < ActiveRecord::Migration
  def self.up
    create_table :todos do |t|
      t.integer :action_item_id
      t.integer :answer_id
      t.date :due_on
      t.integer :user_id
      t.string :note

      t.timestamps
    end
  end

  def self.down
    drop_table :todos
  end
end
