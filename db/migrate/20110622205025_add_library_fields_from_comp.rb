class AddLibraryFieldsFromComp < ActiveRecord::Migration
  def self.up
    add_column :articles, :description, :string
    add_column :articles, :visibility, :string, :default => 'private'
    add_column :articles, :critical_function, :string
    add_column :articles, :on_critical_list, :boolean, :default => false
    remove_column :articles, :is_public 
    remove_column :articles, :tags
    rename_column :articles, :content, :body
  end

  def self.down
    rename_column :articles, :body, :content
    remove_column :articles, :on_critical_list
    remove_column :articles, :critical_function
    remove_column :articles, :visibility
    remove_column :articles, :description
    add_column :articles, :tags, :string
    add_column :articles, :is_public, :boolean,       :default => false
  end
end