class Route < ActiveRecord::Base
  after_commit :set_start_end_stations
  before_save :nil_stations

  belongs_to :start_station, class_name: "Station"
  belongs_to :end_station, class_name: "Station"
  has_many :route_stations, inverse_of: :route, dependent: :destroy
  has_many :stations, through: :route_stations

  accepts_nested_attributes_for :route_stations, allow_destroy: true, reject_if: :all_blank
  validates :start_station_id, :end_station_id, presence: true
  validate :at_least_two_stations
  validate :at_least_one_day

  def skipped_stations
    route_stations.where(is_missed: true).map{|s| s.station.name}
  end

  def visited_stations
    route_stations.where(is_missed: false).map{|s| s.station.name}
  end

  protected

  # Перед обновлением записи обнуляем станции
  def nil_stations
    self.start_station_id = nil
    self.end_station_id = nil
  end

  # В маршруте хотя бы одна станция без пропуска
  def at_least_one_day
    days = [mon, tues, wed, thurs, fri, sat, sun]
    errors.add(:route, 'must have at least one day') if days.select{|d| d}.empty?
  end

  # В маршруте хотя бы одна станция без пропуска
  def at_least_two_stations
    errors.add(:route, 'must have at least two stations') if route_stations.select{|k| !k.is_missed && !k.marked_for_destruction?}.size < 2
  end

  # Первая и конечная станции вычисляются временами прибытия
  def set_start_end_stations
    rs = route_stations.select{|k| !k.is_missed && !k.marked_for_destruction?}.sort_by {|x| x[:arrival_time]}
    update_columns(start_station_id: rs.first.station_id, end_station_id: rs.last.station_id) if !rs.blank?
  end
end
