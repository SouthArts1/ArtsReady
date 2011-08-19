class TweaksForCrisisUpdates < ActiveRecord::Migration
  def self.up
    change_column_default :needs, :provided, false
    remove_column :updates, :title
  end

  def self.down
    add_column :updates, :title, :string
  end
end
