class CreateSlots < ActiveRecord::Migration
  def self.up
    create_table :slots do |t|
      t.date :date_on
      t.time :start_time
      t.time :end_time
      t.integer :available_timing_id
      t.integer :status, :default=>0
      t.integer :client_id
      t.integer :lawyer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :slots
  end
end
