class Station < ActiveRecord::Base
  belongs_to :tariff_zone
  before_destroy :any_route?
  
  has_many :route_starts, class_name: "Station", foreign_key: "start_station_id"
  has_many :route_ends, class_name: "Station", foreign_key: "end_station_id"
  has_many :route_stations, dependent: :destroy
  has_many :routes, through: :route_stations

  accepts_nested_attributes_for :tariff_zone, reject_if: :all_blank

  validates :name, :number, presence: true
  validates :name, length: {maximum: 64}
  validates :number, numericality: { greater_than: 0 }, uniqueness: true
  
  protected
  
  # Станция не должна принадлежать маршруту и выступать в качестве отправной или конечной станции
  def any_route?
    count = self.routes.select{|r| r.start_station_id == self.id || r.end_station_id == self.id}.size
    count > 0 ? errors.add(:base, :any_route) : (return true)
    false
  end
end
