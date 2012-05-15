class CreateClientDetails < ActiveRecord::Migration
  def self.up
    create_table :client_details do |t|
      t.string :address
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :client_details
  end
end

