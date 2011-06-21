class AddCoordsToOrg < ActiveRecord::Migration
  def self.up
    add_column :organizations, :latitude, :float
    add_column :organizations, :longitude, :float
    add_column :organizations, :gmaps, :boolean
  end

  def self.down
    remove_column :organizations, :gmaps
    remove_column :organizations, :longitude
    remove_column :organizations, :latitude
  end
end