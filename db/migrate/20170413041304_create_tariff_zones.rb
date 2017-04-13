class CreateTariffZones < ActiveRecord::Migration
  def change
    create_table :tariff_zones do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
