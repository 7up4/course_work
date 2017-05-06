class Route < ActiveRecord::Base
  attr_accessor :arrivals

  belongs_to :start_station, class_name: "Station", dependent: :destroy
  belongs_to :end_station, class_name: "Station", dependent: :destroy
  has_many :route_stations, inverse_of: :route, dependent: :destroy
  has_many :stations, through: :route_stations

  accepts_nested_attributes_for :route_stations, allow_destroy: true, reject_if: :all_blank

  # validate :at_least_one_day
  # validate :at_least_two_stations

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

  # def at_least_one_day
  #   if [self.monday, self.tuesday, self.wednesday, self.thursday, self.friday, self.saturday, self.sunday].reject(&:blank?).size == 0
  #     errors.add(:route, "Please choose at least one day.")
  #   end
  # end
  #
  # def at_least_two_stations
  #   if self.arrivals.values.select{|arrival| !arrival[:hour].blank? && !arrival[:minute].blank?}.size < 2
  #     errors.add(:route, "Please choose at least two stations.")
  #   end
  # end

  # Первая и конечная станции вычисляются временам прибытия
  # def set_start_end_stations
  #   routes = self.route_stations.where.not(arrival_time: nil).order(arrival_time: :asc)
  #   if routes.blank?
  #     self.update_columns(start_station_id: nil, end_station_id: nil)
  #   else
  #     start = routes.first
  #     finish = routes.last
  #     self.update_columns(start_station_id: start.station_id, end_station_id: finish.station_id)
  #   end
  # end
end
