class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.string :title
      t.text :description
      t.integer :lawyer_id
      t.timestamps
    end
     add_column :images, :avatar_file_name,    :string
      add_column :images, :avatar_content_type, :string
      add_column :images, :avatar_file_size,    :integer
      add_column :images, :avatar_updated_at,   :datetime
  end

  def self.down
    drop_table :images
  end
end
