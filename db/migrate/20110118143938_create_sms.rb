class CreateSms < ActiveRecord::Migration
  def self.up
    create_table :sms do |t|
      t.string :phone_number
      t.string :verification_code
      t.integer :verified, :default=>0
      t.integer :user_id
      t.string :carrier
      t.timestamps
    end
  end

  def self.down
    drop_table :sms
  end
end

