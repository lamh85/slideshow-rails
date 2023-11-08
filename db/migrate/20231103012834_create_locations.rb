class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.integer :longitude_degrees
      t.integer :longitude_minutes
      t.string :longitude_direction
      t.integer :latitude_degrees
      t.integer :latitude_minutes
      t.string :latitude_direction
      t.string :city
      t.string :country

      t.timestamps
    end
  end
end
