class ChangeColumnsToDecimal < ActiveRecord::Migration[7.0]
  def change
    change_column :locations, :longitude_degrees, :decimal, precision: 3, scale: 0
    change_column :locations, :latitude_degrees, :decimal, precision: 3, scale: 0
  end
end
