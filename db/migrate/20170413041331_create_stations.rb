class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string :name, null: false
      t.integer :number, null: false
      t.references :tariff_zone, index: true, foreign_key: true

      t.timestamps null: false
    end
    reversible do |dir|
      dir.up do
        execute("ALTER TABLE stations ADD CONSTRAINT positive_number CHECK (number > 0)")
      end
    end
  end
end
