class CreateAssessments < ActiveRecord::Migration
  def self.up
    create_table :assessments do |t|
      t.integer :organization_id
      t.string :critical_functions

      t.timestamps
    end
  end

  def self.down
    drop_table :assessments
  end
end
