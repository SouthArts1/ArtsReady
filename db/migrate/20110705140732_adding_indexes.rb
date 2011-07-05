class AddingIndexes < ActiveRecord::Migration
  def self.up
    add_index :action_items, :question_id
    add_index :action_items, :import_id
    add_index :answers, :assessment_id
    add_index :answers, :question_id
    add_index :articles, :user_id
    add_index :articles, :organization_id
    add_index :assessments, :organization_id
    add_index :questions, :import_id
    add_index :resources, :organization_id
    add_index :todos, :action_item_id
    add_index :todos, :answer_id
    add_index :todos, :organization_id
    add_index :todos, :user_id
    add_index :users, :organization_id
  end

  def self.down
    remove_index :users, :organization_id
    remove_index :todos, :action_item_id
    remove_index :todos, :organization_id
    remove_index :todos, :user_id
    remove_index :todos, :answer_id
    remove_index :resources, :organization_id
    remove_index :questions, :import_id
    remove_index :assessments, :organization_id
    remove_index :articles, :organization_id
    remove_index :articles, :user_id
    remove_index :answers, :question_id
    remove_index :answers, :assessment_id
    remove_index :action_items, :import_id
    remove_index :action_items, :question_id
  end
end