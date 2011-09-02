class AddUserCounterCacheForOrgs < ActiveRecord::Migration
  def self.up
    # add_column :organizations, :users_count, :integer, :default => 0
    
    # Organization.reset_column_information
    # Organization.all.each {|p| p.update_counters p.id, :users_count => p.users.length}
  end

  def self.down
    remove_column :organizations, :users_count
  end
end
