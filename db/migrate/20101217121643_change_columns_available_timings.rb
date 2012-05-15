class ChangeColumnsAvailableTimings < ActiveRecord::Migration
  def self.up
       change_column :available_timings, :time_from, :datetime
       change_column :available_timings, :time_to, :datetime
  end

  def self.down
       change_column :available_timings, :time_from, :time
       change_column :available_timings, :time_to, :time
  end
end
