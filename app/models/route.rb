class Route < ActiveRecord::Base
  after_save :set_start_end_stations

  belongs_to :start_station, class_name: "Station", dependent: :destroy
  belongs_to :end_station, class_name: "Station", dependent: :destroy
  has_many :route_stations, inverse_of: :route, dependent: :destroy
  has_many :stations, through: :route_stations

  accepts_nested_attributes_for :route_stations, allow_destroy: true, reject_if: :all_blank

  def skipped_stations
    stations.where("arrival_time IS ?", nil)
  end

  def visited_stations
    stations.where("arrival_time IS NOT ?", nil)
  end

  protected

  # Первая и конечная станции вычисляются временами прибытия
  def set_start_end_stations
    routes = route_stations.where.not(arrival_time: nil).order(arrival_time: :asc)
    routes.blank? ? update_columns(start_station_id: nil, end_station_id: nil) : update_columns(start_station_id: routes.first.station_id, end_station_id: routes.last.station_id)
  end
end
