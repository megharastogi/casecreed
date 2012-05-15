class CreateAvailableTimings < ActiveRecord::Migration
  def self.up
    create_table :available_timings do |t|
      t.date :date_on
      t.time :time_from
      t.time :time_to
      t.integer :lawyer_id
      t.timestamps
    end
  end

  def self.down
    drop_table :available_timings
  end
end
