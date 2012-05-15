class CreateVoteForNextCities < ActiveRecord::Migration
  def self.up
    create_table :vote_for_next_cities do |t|
      t.string :first_name
      t.string :last_name
      t.string :city
      t.string :email
      t.text :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :vote_for_next_cities
  end
end
