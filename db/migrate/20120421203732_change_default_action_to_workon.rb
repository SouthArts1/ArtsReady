class ChangeDefaultActionToWorkon < ActiveRecord::Migration
  def self.up
    change_column :todos, :action, :string, :default => 'Work On'
  end

  def self.down
    change_column :todos, :action, :string, :default => nil
  end
end
