class AddRatingToLawyerDetail < ActiveRecord::Migration
  def self.up
    add_column :lawyer_details, :rating, :float, :default=>0
  end

  def self.down
    remove_column :lawyer_details, :rating
  end
end

