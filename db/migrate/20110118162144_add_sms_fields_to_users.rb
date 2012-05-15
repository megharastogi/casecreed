class AddSmsFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :sms_number, :string
    add_column :users, :sms_carrier, :string
  end

  def self.down
    remove_column :users, :sms_carrier
    remove_column :users, :sms_number
  end
end
