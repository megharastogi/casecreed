class CreateClaims < ActiveRecord::Migration
  def self.up
    create_table :claims do |t|
      t.integer :user_id
      t.text :message

      t.timestamps
    end
  end

  def self.down
    drop_table :claims
  end
end
