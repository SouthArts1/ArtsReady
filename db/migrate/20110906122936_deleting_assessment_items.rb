class DeletingAssessmentItems < ActiveRecord::Migration
  def self.up
    add_column :questions, :deleted, :boolean, :default => false
    add_column :action_items, :deleted, :boolean, :default => false
  end

  def self.down
    remove_column :action_items, :deleted
    remove_column :questions, :deleted
  end
end