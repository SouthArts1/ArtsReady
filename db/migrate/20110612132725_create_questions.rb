class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions, :force => true do |t|
      t.string :description, :critical_function
      t.integer :import_id #temporary id for linking to spreadsheet columns
      t.timestamps
    end
  end

  def self.down
    drop_table :questions
  end
end