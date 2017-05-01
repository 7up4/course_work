class Station < ActiveRecord::Base
  belongs_to :tariff_zone

  before_destroy :remove_associations
  has_many :route_start, class_name: "Station", foreign_key: "start_station_id"
  has_many :route_end, class_name: "Station", foreign_key: "end_station_id"
  has_many :route_stations
  has_many :routes, through: :route_stations

  validates :name, :tariff_zone, :number, presence: true
  validates :number, numericality: { greater_than: 0 }
  protected

  def remove_associations
    self.routes.delete(self.routes)
    Route.where('routes.start_station_id=?', id).each{|r| r.update_columns(start_station_id: nil)}
    Route.where('routes.end_station_id=?', id).each{|r| r.update_columns(end_station_id: nil)}
  end
end
