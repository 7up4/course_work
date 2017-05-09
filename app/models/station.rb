class Station < ActiveRecord::Base
  belongs_to :tariff_zone

  # Надо добавить нулификацию start/end_station_id
  has_many :route_start, class_name: "Station", foreign_key: "start_station_id"
  has_many :route_end, class_name: "Station", foreign_key: "end_station_id"
  has_many :route_stations, dependent: :destroy
  has_many :routes, through: :route_stations

  accepts_nested_attributes_for :tariff_zone, allow_destroy: true, reject_if: :all_blank

  validates :name, :number, presence: true
  validates :number, numericality: { greater_than: 0 }, uniqueness: true
end
