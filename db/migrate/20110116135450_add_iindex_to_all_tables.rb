class AddIindexToAllTables < ActiveRecord::Migration
  def self.up
    add_index :lawyer_categories, :lawyer_id
 add_index :lawyer_categories, :category_id
 add_index :lawyer_details, :user_id
 add_index :appointments, :user_id
 add_index :appointments, :status
 add_index :available_timings, :lawyer_id
 add_index :categories, :parent_category_id
 add_index :claims, :user_id
 add_index :client_details, :user_id
 add_index :reviews, :lawyer_id
 add_index :reviews, :user_id
 add_index :slots, :available_timing_id
 add_index :slots, :client_id
 add_index :slots, :lawyer_id
  end

  def self.down
remove_index :lawyer_categories, :lawyer_id
 remove_index :lawyer_categories, :category_id
 remove_index :lawyer_details, :user_id
 remove_index :appointments, :user_id
 remove_index :appointments, :status
 remove_index :available_timings, :lawyer_id
 remove_index :categories, :parent_category_id
 remove_index :claims, :user_id
 remove_index :client_details, :user_id
 remove_index :images, :lawyer_id
 remove_index :reviews, :lawyer_id
 remove_index :reviews, :user_id
 remove_index :slots, :available_timing_id
 remove_index :slots, :client_id
 remove_index :slots, :lawyer_id
  end
end

