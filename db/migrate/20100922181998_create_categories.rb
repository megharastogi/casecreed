class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.text :name
      t.integer :parent_category_id
      t.text :description
      t.timestamps
    end
end
  def self.down
    drop_table :categories
  end
end

