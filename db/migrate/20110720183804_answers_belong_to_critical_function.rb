class AnswersBelongToCriticalFunction < ActiveRecord::Migration
  def self.up
    add_column :answers, :critical_function, :string
    add_index :answers, :critical_function
  end

  def self.down
    remove_index :answers, :critical_function
    remove_column :answers, :critical_function
  end
end