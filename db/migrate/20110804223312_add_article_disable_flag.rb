class AddArticleDisableFlag < ActiveRecord::Migration
  def self.up
    add_column :articles, :disabled, :boolean, :default => false
  end

  def self.down
    remove_column :articles, :disabled
  end
end