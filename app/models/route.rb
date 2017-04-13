class Route < ActiveRecord::Base
  belongs_to :start, class_name: "Station", foreign_key: "start_station_id"
  belongs_to :end, class_name: "Station", foreign_key: "end_station_id"
  has_many :route_stations
  has_many :stations, through: :route_stations

  after_create :add_stations

  protected

  def add_stations
    Station.all.each do |s|
      self.stations<<s
    end
  end

end
