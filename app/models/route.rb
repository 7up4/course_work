class Route < ActiveRecord::Base
  after_commit :set_start_end_stations
  before_save :nil_stations
  before_validation :has_no_relations
  belongs_to :start_station, class_name: "Station"
  belongs_to :end_station, class_name: "Station"
  has_many :route_stations, inverse_of: :route, dependent: :destroy
  has_many :stations, through: :route_stations

  accepts_nested_attributes_for :route_stations, allow_destroy: true, reject_if: :all_blank
  validate :validate_unique_station_num
  validate :validate_unique_station
  validates :start_station_id, :end_station_id, presence: true
  validate :at_least_two_stations
  validate :at_least_one_day
  validate :uniq_stations
  
  def skipped_stations
    route_stations.where(is_missed: true).map{|s| s.station.name}
  end
  
  def self.search(params)
    result = Route.eager_load(route_stations: :station, stations: :tariff_zone)
    params[:route].each do |attr,val|
      next if val.to_s.blank?
      if attr == 'start_station' || attr == 'end_station'
        result = result.where(attr=>Station.where(name: val))
        next
      end
      result = result.where(attr=>val)
    end
    params[:route_station].each do |attr,val|
      next if val.to_s.blank?
      result = result.where(route_stations: {attr=>val})
    end
    params[:tariff_zone].each do |attr,val|
      next if val.to_s.blank?
      result = result.where(tariff_zones: {attr=>val})
    end
    params[:station].each do |attr,val|
      next if val.to_s.blank?
      result = result.where(stations: {attr=>val})
    end
    return result
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
    stations = rs.map{|x| x.station}.uniq
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
  
  def has_no_relations
    self.route_stations.each do |rs|
      rs.station.reload if rs.station.marked_for_destruction? && rs.station.route_stations.select{|v| v.id!=rs.id}.present?
    end
  end
  
  def validate_unique_station
    self.route_stations.each{|rs| rs.station.skip_station_name=true}
    validate_uniqueness_of_in_memory(self.route_stations.map{|s| s.station}, [:name], 'Duplicate station name.')
  end
  
  def validate_unique_station_num
    self.route_stations.each{|rs| rs.station.skip_station_number=true}
    validate_uniqueness_of_in_memory(self.route_stations.map{|s| s.station}, [:number], 'Duplicate station number.')
  end
end
