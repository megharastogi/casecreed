class AddEmailToClaim < ActiveRecord::Migration
  def self.up
    add_column :claims, :email, :string
    add_column :claims, :phone, :string
  end

  def self.down
    remove_column :claims, :email
     remove_column :claims, :phone, :string
  end
end
