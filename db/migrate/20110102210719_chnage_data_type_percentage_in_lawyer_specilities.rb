class ChnageDataTypePercentageInLawyerSpecilities < ActiveRecord::Migration
  def self.up
         change_column :lawyer_categories, :percentage, :integer
  end

  def self.down
         change_column :lawyer_categories, :percentage, :float
  end
end

