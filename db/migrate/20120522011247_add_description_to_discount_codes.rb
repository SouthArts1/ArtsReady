class AddDescriptionToDiscountCodes < ActiveRecord::Migration
  def self.up
    add_column :discount_codes, :description, :string
  end

  def self.down
    remove_column :discount_codes, :description
  end
end
