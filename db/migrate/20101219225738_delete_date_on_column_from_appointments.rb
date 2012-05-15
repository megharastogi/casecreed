class DeleteDateOnColumnFromAppointments < ActiveRecord::Migration
  def self.up
    remove_column :appointments, :date_on
    remove_column :appointments, :time_from
    remove_column :appointments, :time_to
    add_column :appointments, :slot_id, :integer
  end

  def self.down
    remove_column :appointments, :slot_id
    add_column :appointments, :date_on, :datetime
    add_column :appointments, :time_from, :datetime
    add_column :appointments, :time_to, :datetime
  end
end

