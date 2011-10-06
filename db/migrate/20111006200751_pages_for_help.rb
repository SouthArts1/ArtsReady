class PagesForHelp < ActiveRecord::Migration
  def self.up
    Page.create(:title => 'Help: Assessment', :slug => 'help_assessment', :body => 'Help for Assessment')
    Page.create(:title => 'Help: Battle Buddy Network', :slug => 'help_battle_buddies', :body => 'Help for BBN')
    Page.create(:title => 'Help: Dashboard', :slug => 'help_dashboard', :body => 'Help for Dashboard')
    Page.create(:title => 'Help: Library', :slug => 'help_library', :body => 'Help for Library')
    Page.create(:title => 'Help: To-Dos', :slug => 'help_todos', :body => 'Help for To-Dos')
  end
  def self.down
    Page.find_by_slug('help_assessment').destroy
    Page.find_by_slug('help_battle_buddies').destroy
    Page.find_by_slug('help_dashboard').destroy
    Page.find_by_slug('help_library').destroy
    Page.find_by_slug('help_todos').destroy
  end
end
