class AddAreaServedToLawyerDetails < ActiveRecord::Migration
  def self.up
    add_column :lawyer_details, :area_served, :text
  end

  def self.down
    remove_column :lawyer_details, :area_served
  end
end
