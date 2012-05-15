class AddProfessionalStatementToLawyerDetails < ActiveRecord::Migration
  def self.up
    add_column :lawyer_details, :professional_statement, :text
  end

  def self.down
    remove_column :lawyer_details, :professional_statement
  end
end
