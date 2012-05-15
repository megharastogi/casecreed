class AddActiveToSlots < ActiveRecord::Migration
  def self.up
    add_column :slots, :active, :integer, :default=> 1
  end

  def self.down
    remove_column :slots, :active
  end
end
