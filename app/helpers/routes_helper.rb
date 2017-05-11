module RoutesHelper
  def station_name(station)
    station.present? ? station.name : "Не указана"
  end
  
  def get_days(route)
    days = {"пн.": route.mon, "вт.": route.tues, "ср.": route.wed, "чт.": route.thurs, "пт.": route.fri, "сб.": route.sat, "вс.": route.sun}
    if days.values.count(true) == days.size
      "Ежедневно"
    elsif days.values[0,5].count(true) == 5
      "По рабочим"
    elsif days.values[5,2].count(true) == 2
      "По выходным"
    else
      days.select{|key, value| key if value}.keys.join(", ")
    end
  end
end
