class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string :name, null: false
      t.integer :number
      t.references :tariff_zone, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
