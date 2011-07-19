class AssessmentTrackingFields < ActiveRecord::Migration
  def self.up
    add_column :assessments, :complete, :boolean, :default => false
    add_column :assessments, :answers_count, :integer, :default => 0
    add_column :assessments, :completed_answers_count, :integer, :default => 0
  end

  def self.down
    remove_column :assessments, :completed_answers_count
    remove_column :assessments, :complete
    remove_column :assessments, :answers_count
  end
end