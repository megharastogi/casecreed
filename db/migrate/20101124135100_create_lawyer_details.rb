class CreateLawyerDetails < ActiveRecord::Migration
  def self.up
    create_table :lawyer_details do |t|
      t.integer :user_id
      t.text :address
      t.string :home_phone
      t.string :work_phone
      t.string :office_phone
      t.string :fax
      t.string :toll_free_phone
      t.string :language
      t.text :description
      t.string :website
      t.string :firm_name
      t.integer :firm_size
      t.string :experience
      t.text :professional_membership
      t.float :latitude
      t.float :longitude
      t.text :awards
      t.text :education
      t.timestamps
    end

  end

  def self.down
    drop_table :lawyer_details
  end
end