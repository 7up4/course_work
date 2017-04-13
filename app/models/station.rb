class Station < ActiveRecord::Base
  belongs_to :tariff_zone
  has_many :route_stations
  has_many :routes, through: :route_stations
  
  validates :name, presence: true
end
