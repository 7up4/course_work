class Route < ActiveRecord::Base
  before_validation :set_start_end_stations

  belongs_to :start_station, class_name: "Station"
  belongs_to :end_station, class_name: "Station"
  has_many :route_stations, inverse_of: :route, dependent: :destroy
  has_many :stations, through: :route_stations

  accepts_nested_attributes_for :route_stations, allow_destroy: true, reject_if: :all_blank
  validates :start_station_id, :end_station_id, presence: true

  def skipped_stations
    stations.where("arrival_time IS ?", nil)
  end

  def visited_stations
    stations.where("arrival_time IS NOT ?", nil)
  end

  protected

  # Первая и конечная станции вычисляются временами прибытия
  def set_start_end_stations
    routes = route_stations.select{|rs| !rs.arrival_time.nil? && !rs.marked_for_destruction?}
    if self.new_record? && !routes.blank?
      if self.start_station_id.nil? || self.end_station_id.nil?
        self.update_attributes(start_station_id: routes.first.station_id, end_station_id: routes.last.station_id)
      end
    elsif !self.new_record?
      if !routes.blank?
        self.update_columns(start_station_id: routes.first.station_id, end_station_id: routes.last.station_id)
      else
        self.start_station_id = nil
        self.end_station_id = nil
      end
    end
  end
end
