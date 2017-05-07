module RoutesHelper
  def station_name(station)
    station.present? ? station.name : "Не указана"
  end
end
