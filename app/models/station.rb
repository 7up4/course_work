class Station < ActiveRecord::Base
  attr_accessor :remove_tariff_zone
  
  belongs_to :tariff_zone
  before_destroy :any_route?
  after_save :destroy_tariff_zone
  
  has_many :route_starts, class_name: "Station", foreign_key: "start_station_id"
  has_many :route_ends, class_name: "Station", foreign_key: "end_station_id"
  has_many :route_stations, dependent: :destroy
  has_many :routes, through: :route_stations

  accepts_nested_attributes_for :tariff_zone, allow_destroy: true, reject_if: :all_blank

  validates :name, :number, :tariff_zone, presence: true
  validates :name, length: {maximum: 64}
  validates :number, numericality: { greater_than: 0 }, uniqueness: true
  
  protected
  
  def destroy_tariff_zone
    if remove_tariff_zone.present?
      relationship = TariffZone.find(remove_tariff_zone).stations.select{|s| s.id!=self.id}
      TariffZone.destroy(remove_tariff_zone) if relationship.empty?
    end
  end
  
  # Станция не должна принадлежать маршруту и выступать в качестве отправной или конечной станции
  def any_route?
    count = self.routes.select{|r| r.start_station_id == self.id || r.end_station_id == self.id}.size
    count > 0 ? errors.add(:base, :any_route) : (return true)
    false
  end
end
