class CreateTariffZones < ActiveRecord::Migration
  def change
    create_table :tariff_zones do |t|
      t.string :name, limit: 64, null: false

      t.index :name, unique: true
      t.timestamps null: false
    end
  end
end
