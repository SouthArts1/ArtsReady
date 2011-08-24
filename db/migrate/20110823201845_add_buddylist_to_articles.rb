class AddBuddylistToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :buddy_list, :string
  end

  def self.down
    remove_column :articles, :buddy_list
  end
end