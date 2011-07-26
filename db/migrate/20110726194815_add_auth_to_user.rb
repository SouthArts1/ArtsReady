class AddAuthToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :role, :string
    add_column :users, :last_login_at, :datetime
  end

  def self.down
    remove_column :users, :last_login_at
    remove_column :users, :role
  end
end