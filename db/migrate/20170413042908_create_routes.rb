class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.integer :start_station_id, limit: 8
      t.integer :end_station_id, limit: 8
      t.boolean :mon
      t.boolean :tues
      t.boolean :wed
      t.boolean :thurs
      t.boolean :fri
      t.boolean :sat
      t.boolean :sun

      t.timestamps null: false
    end
    reversible do |dir|
      dir.up do
        execute("ALTER TABLE routes ADD FOREIGN KEY(start_station_id) REFERENCES stations(id)")
        execute("ALTER TABLE routes ADD FOREIGN KEY(end_station_id) REFERENCES stations(id)")
        execute(
          "ALTER TABLE routes ADD CONSTRAINT at_least_one_day CHECK (mon = TRUE OR
            tues = TRUE OR
            wed = TRUE OR
            thurs = TRUE OR
            fri = TRUE OR
            sat = TRUE OR
            sun = TRUE
          )"
        )
      end
    end
  end
end
