class Route < ActiveRecord::Base
  attr_accessor :arrivals

  belongs_to :start, class_name: "Station", foreign_key: "start_station_id"
  belongs_to :end, class_name: "Station", foreign_key: "end_station_id"
  has_many :route_stations, dependent: :destroy
  has_many :stations, through: :route_stations

  before_create :add_stations
  after_save :set_arrival_time, :set_start_end_stations

  # Получение из params времени прибытия
  def pass_attrs_to_model(attr)
    self.arrivals = attr
  end

  def skipped_stations
    self.stations.where("arrival_time IS ?", nil)
  end

  def visited_stations
    self.stations.where("arrival_time IS NOT ?", nil)
  end

  protected

  # Первая и конечная станции вычисляются временам прибытия
  def set_start_end_stations
    routes = self.route_stations.where.not(arrival_time: nil).order(arrival_time: :asc)
    if routes.blank?
      self.update_columns(start_station_id: nil, end_station_id: nil)
    else
      start = routes.first
      finish = routes.last
      self.update_columns(start_station_id: start.station_id, end_station_id: finish.station_id)
    end
  end

  def add_stations
    Station.all.each{ |s| self.stations<<s }
  end

  def set_arrival_time
    self.stations.each do |s|
      route_station=s.route_stations.where(station_id: s, route_id: self)
      if !self.arrivals[s.id.to_s][:hour].blank? && !self.arrivals[s.id.to_s][:minute].blank?
        t=Time.zone.parse(self.arrivals[s.id.to_s][:hour]+":"+self.arrivals[s.id.to_s][:minute])
      end
      route_station.update_all(arrival_time: t)
    end
  end
end
