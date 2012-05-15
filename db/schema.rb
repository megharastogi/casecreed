# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110118162144) do

  create_table "appointments", :force => true do |t|
    t.text     "description"
    t.integer  "lawyer_id"
    t.integer  "user_id"
    t.integer  "status",      :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "slot_id"
  end

  add_index "appointments", ["status"], :name => "index_appointments_on_status"
  add_index "appointments", ["user_id"], :name => "index_appointments_on_user_id"

  create_table "available_timings", :force => true do |t|
    t.date     "date_on"
    t.datetime "time_from"
    t.datetime "time_to"
    t.integer  "lawyer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "available_timings", ["lawyer_id"], :name => "index_available_timings_on_lawyer_id"

  create_table "categories", :force => true do |t|
    t.text     "name"
    t.integer  "parent_category_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["parent_category_id"], :name => "index_categories_on_parent_category_id"

  create_table "claims", :force => true do |t|
    t.integer  "user_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "phone"
  end

  add_index "claims", ["user_id"], :name => "index_claims_on_user_id"

  create_table "client_details", :force => true do |t|
    t.string   "address"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "client_details", ["user_id"], :name => "index_client_details_on_user_id"

  create_table "images", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "lawyer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "lawyer_categories", :force => true do |t|
    t.integer  "lawyer_id"
    t.integer  "category_id"
    t.string   "category_type"
    t.integer  "percentage"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lawyer_categories", ["category_id"], :name => "index_lawyer_categories_on_category_id"
  add_index "lawyer_categories", ["lawyer_id"], :name => "index_lawyer_categories_on_lawyer_id"

  create_table "lawyer_details", :force => true do |t|
    t.integer  "user_id"
    t.text     "address"
    t.string   "home_phone"
    t.string   "work_phone"
    t.string   "office_phone"
    t.string   "fax"
    t.string   "toll_free_phone"
    t.string   "language"
    t.text     "description"
    t.string   "website"
    t.string   "firm_name"
    t.integer  "firm_size"
    t.string   "experience"
    t.text     "professional_membership"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "awards"
    t.text     "education"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "area_served"
    t.text     "professional_statement"
    t.float    "rating",                  :default => 0.0
  end

  add_index "lawyer_details", ["user_id"], :name => "index_lawyer_details_on_user_id"

  create_table "messages", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.string   "category"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviews", :force => true do |t|
    t.float    "rating"
    t.text     "comment"
    t.integer  "lawyer_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reviews", ["lawyer_id"], :name => "index_reviews_on_lawyer_id"
  add_index "reviews", ["user_id"], :name => "index_reviews_on_user_id"

  create_table "slots", :force => true do |t|
    t.date     "date_on"
    t.time     "start_time"
    t.time     "end_time"
    t.integer  "available_timing_id"
    t.integer  "status",              :default => 0
    t.integer  "client_id"
    t.integer  "lawyer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "active",              :default => 1
  end

  add_index "slots", ["available_timing_id"], :name => "index_slots_on_available_timing_id"
  add_index "slots", ["client_id"], :name => "index_slots_on_client_id"
  add_index "slots", ["lawyer_id"], :name => "index_slots_on_lawyer_id"

  create_table "sms", :force => true do |t|
    t.string   "phone_number"
    t.string   "verification_code"
    t.integer  "verified",          :default => 0
    t.integer  "user_id"
    t.string   "carrier"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "sex"
    t.string   "city"
    t.string   "zipcode"
    t.string   "state"
    t.string   "salt"
    t.string   "hashed_password"
    t.string   "account_type",         :default => "user"
    t.string   "email"
    t.string   "remember_me"
    t.string   "activation_code"
    t.integer  "active",               :default => 0
    t.string   "forgot_password_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "approved"
    t.string   "sms_number"
    t.string   "sms_carrier"
  end

  create_table "vote_for_next_cities", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "city"
    t.string   "email"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
