class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.integer :start_station_id, limit: 8
      t.integer :end_station_id, limit: 8
      t.boolean :monday
      t.boolean :tuesday
      t.boolean :wednesday
      t.boolean :thursday
      t.boolean :friday
      t.boolean :saturday
      t.boolean :sunday

      t.timestamps null: false
    end
    reversible do |dir|
      dir.up do
        execute("ALTER TABLE routes ADD FOREIGN KEY(start_station_id) REFERENCES stations(id)")
        execute("ALTER TABLE routes ADD FOREIGN KEY(end_station_id) REFERENCES stations(id)")
      end
    end
  end
end
