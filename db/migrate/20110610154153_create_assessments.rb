class CreateAssessments < ActiveRecord::Migration
  def self.up
    create_table :assessments do |t|
      t.integer :organization_id
      t.string :config

      t.timestamps
    end
  end

  def self.down
    drop_table :assessments
  end
end
