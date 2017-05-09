class Route < ActiveRecord::Base
  after_commit :set_start_end_stations
  before_save :nil_stations

  belongs_to :start_station, class_name: "Station"
  belongs_to :end_station, class_name: "Station"
  has_many :route_stations, inverse_of: :route, dependent: :destroy
  has_many :stations, through: :route_stations

  accepts_nested_attributes_for :route_stations, allow_destroy: true, reject_if: :all_blank
  validates :start_station_id, :end_station_id, presence: true

  def skipped_stations
    route_stations.where("arrival_time IS ?", nil).map{|s| s.station.name}
  end

  def visited_stations
    route_stations.where("arrival_time IS NOT ?", nil).map{|s| s.station.name}
  end

  protected

  # Перед обновлением записи обнуляем станции
  def nil_stations
    self.start_station_id = nil
    self.end_station_id = nil
  end

  # Первая и конечная станции вычисляются временами прибытия
  def set_start_end_stations
    rs = route_stations.select{|k| !k.arrival_time.nil? && !k.marked_for_destruction?}.sort_by {|x| x[:arrival_time]}
    update_columns(start_station_id: rs.first.station_id, end_station_id: rs.last.station_id) if !rs.blank?
  end
end
