class CreateRouteStations < ActiveRecord::Migration
  def change
    create_table :route_stations do |t|
      t.references :station, index: true, foreign_key: true
      t.references :route, index: true, foreign_key: true
      t.time :arrival_time

      t.index [:station_id, :route_id], unique: true
      t.timestamps null: false
    end
  end
end
