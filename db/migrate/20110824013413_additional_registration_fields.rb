class AdditionalRegistrationFields < ActiveRecord::Migration
  def self.up
    add_column :organizations, :phone_number, :string
    add_column :organizations, :email, :string
    add_column :organizations, :contact_name, :string
  end

  def self.down
    remove_column :organizations, :contact_name
    remove_column :organizations, :email
    remove_column :organizations, :phone_number
  end
end