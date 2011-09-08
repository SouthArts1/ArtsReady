class AddHelpToQuestion < ActiveRecord::Migration
  def self.up
    add_column :questions, :help, :text
  end

  def self.down
    remove_column :questions, :help
  end
end