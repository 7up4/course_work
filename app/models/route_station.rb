class RouteStation < ActiveRecord::Base
  belongs_to :station
  belongs_to :route

  validates :station, uniqueness: {scope: :route, message: "one station per route" }
end
