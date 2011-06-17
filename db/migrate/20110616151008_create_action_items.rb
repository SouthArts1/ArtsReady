class CreateActionItems < ActiveRecord::Migration
  def self.up
    create_table :action_items do |t|
      t.string :description
      t.integer :question_id
      t.integer :import_id
      t.string :recurrence

      t.timestamps
    end
  end

  def self.down
    drop_table :action_items
  end
end
