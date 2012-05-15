class ChnageStatusDefaultValueInAppointment < ActiveRecord::Migration
  def self.up
       change_column :appointments, :status, :integer, :default=> 1
  end

  def self.down
      change_column :appointments, :status, :integer
  end
end

