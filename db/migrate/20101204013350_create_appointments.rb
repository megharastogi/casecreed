class CreateAppointments < ActiveRecord::Migration
  def self.up
    create_table :appointments do |t|
      t.datetime :date_on
      t.datetime :time_from
      t.datetime :time_to
      t.text :description
      t.integer :lawyer_id
      t.integer :user_id
      t.integer :status
      t.timestamps
    end
  end

  def self.down
    drop_table :appointments
  end
end
