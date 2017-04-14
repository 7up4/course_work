class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.integer :start_station_id, index: true
      t.integer :end_station_id, index:true
      t.boolean :monday
      t.boolean :tuesday
      t.boolean :wednesday
      t.boolean :thursday
      t.boolean :friday
      t.boolean :saturday
      t.boolean :sunday

      t.timestamps null: false
    end
    add_foreign_key :routes, :stations, column: :start_station_id
    add_foreign_key :routes, :stations, column: :end_station_id
  end
end
