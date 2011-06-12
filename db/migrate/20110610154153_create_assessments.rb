class CreateAssessments < ActiveRecord::Migration
  def self.up
    create_table :assessments do |t|
      t.integer :organization_id
      t.boolean :has_performances, :has_tickets, :has_facilities, :has_programs, :has_grants, :has_exhibits
      t.timestamps
    end
  end
  
  def self.down
    drop_table :assessments
  end
end
