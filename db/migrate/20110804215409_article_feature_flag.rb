class ArticleFeatureFlag < ActiveRecord::Migration
  def self.up
    add_column :articles, :featured, :boolean, :default => false
  end

  def self.down
    remove_column :articles, :featured
  end
end