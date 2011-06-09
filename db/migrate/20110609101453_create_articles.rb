class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :title, :tags, :link, :document
      t.text :content
      t.date :published_on
      t.integer :owner_id, :organization_id
      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
