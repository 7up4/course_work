class CreateRouteStations < ActiveRecord::Migration
  def change
    create_table :route_stations do |t|
      t.references :station, index: true, foreign_key: true, null: false
      t.references :route, index: true, foreign_key: true, null: false
      # Если время прибытия отсутствует, то эта станция пропускается
      # Т.к. значение поля можно получить на основании значения другого, то его можно опустить
      t.time :arrival_time

      t.timestamps null: false
    end
  end
end
