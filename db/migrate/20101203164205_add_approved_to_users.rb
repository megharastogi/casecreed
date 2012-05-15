class AddApprovedToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :approved, :integer,:default=>nil
  end

  def self.down
    remove_column :users, :approved
  end
end
