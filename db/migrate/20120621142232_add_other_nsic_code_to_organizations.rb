class AddOtherNsicCodeToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :other_nsic_code, :string
  end

  def self.down
    remove_column :organizations, :other_nsic_code
  end
end
