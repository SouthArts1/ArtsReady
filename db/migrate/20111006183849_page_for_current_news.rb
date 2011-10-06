class PageForCurrentNews < ActiveRecord::Migration
  def self.up
    Page.create(:title => 'Current News', :slug => 'news', :body => 'Current News')
  end

  def self.down
    Page.find_by_slug('news').destroy
  end
end
