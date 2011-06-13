class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.integer :assessment_id, :question_id
      t.string :preparedness, :priority
      t.boolean :was_skipped
      t.timestamps
    end
  end

  def self.down
    drop_table :answers
  end
end
