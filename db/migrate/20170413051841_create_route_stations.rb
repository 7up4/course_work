class CreateRouteStations < ActiveRecord::Migration
  def change
    create_table :route_stations do |t|
      t.references :station, index: true, foreign_key: true, null: false
      t.references :route, index: true, foreign_key: true, null: false

      t.boolean :is_missed, null: false, default: false
      t.time :arrival_time

      t.timestamps null: false
    end
    reversible do |dir|
      dir.up do
        execute("ALTER TABLE route_stations ADD CONSTRAINT missed CHECK (is_missed=true OR is_missed=false AND arrival_time IS NOT NULL)")
      end
    end
  end
end
