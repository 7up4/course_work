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
  validate :uniq_stations
  
  def skipped_stations
    route_stations.where(is_missed: true).map{|s| s.station.name}
  end

  protected

  # Перед обновлением записи обнуляем станции
  def nil_stations
    self.start_station_id = nil
    self.end_station_id = nil
  end

  # В маршруте не должно быть одинаковых станций
  def uniq_stations
    rs = route_stations.select{|k| !k.marked_for_destruction?}
    stations = rs.map{|x| x.station_id}.uniq
    errors.add(:base, :uniq_stations) if stations.length < rs.length
  end
  
  # В маршруте хотя бы одна станция без пропуска
  def at_least_one_day
    days = [mon, tues, wed, thurs, fri, sat, sun]
    errors.add(:base, :at_least_one_day) if !days.include? true
  end

  # В маршруте хотя бы две станции без пропуска
  def at_least_two_stations
    errors.add(:base, :at_least_two_stations) if route_stations.select{|k| !k.is_missed && !k.marked_for_destruction?}.size < 2
  end

  # Первая и конечная станции вычисляются временами прибытия
  def set_start_end_stations
    rs = route_stations.select{|k| !k.is_missed && !k.marked_for_destruction?}.sort_by {|x| x[:arrival_time]}
    update_columns(start_station_id: rs.first.station_id, end_station_id: rs.last.station_id) if !rs.blank?
  end
end
