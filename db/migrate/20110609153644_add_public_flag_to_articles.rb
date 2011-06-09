class AddPublicFlagToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :is_public, :boolean, :default => false
  end

  def self.down
    remove_column :articles, :is_public
  end
end