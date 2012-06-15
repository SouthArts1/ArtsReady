class AddCompletedAtToAssessments < ActiveRecord::Migration
  def self.up
    add_column :assessments, :completed_at, :datetime
    add_index :assessments, :completed_at
  end

  def self.down
    remove_column :assessments, :completed_at
  end
end
