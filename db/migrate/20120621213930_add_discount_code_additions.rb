class AddDiscountCodeAdditions < ActiveRecord::Migration
  def self.up
    add_column :discount_codes, :recurring_deduction_value, :integer, :default => 0
    add_column :discount_codes, :recurring_deduction_type, :string, :default => "dollar"
  end

end
