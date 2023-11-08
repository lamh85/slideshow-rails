class AddColumnLimitsToLocations < ActiveRecord::Migration[7.0]
  def change
    change_column :locations, :country, :string, limit: 2
    change_column :locations, :longitude_degrees, :numeric, precision: 3, scale: 0
    change_column :locations, :latitude_degrees, :numeric, precision: 3, scale: 0
  end
end
