class Station < ActiveRecord::Base
  attr_accessor :remove_tariff_zone
  
  belongs_to :tariff_zone
  before_destroy :any_route?
  after_save :destroy_tariff_zone
  before_validation :avoid_uniqueness_fail
  
  has_many :route_starts, class_name: "Station", foreign_key: "start_station_id"
  has_many :route_ends, class_name: "Station", foreign_key: "end_station_id"
  has_many :route_stations, dependent: :destroy
  has_many :routes, through: :route_stations

  accepts_nested_attributes_for :tariff_zone, allow_destroy: true, reject_if: :all_blank

  validates :name, :number, :tariff_zone, presence: true
  validates :name, length: {maximum: 64}, uniqueness: true
  validates :number, numericality: { greater_than: 0 }, uniqueness: true
  
  protected
  
  def avoid_uniqueness_fail
    if remove_tariff_zone.present?
      tz_to_remove = TariffZone.find(remove_tariff_zone)
      if tz_to_remove.present?
        tmp_name = random_string
        tz_to_remove.update_attributes(name: tmp_name)
      end
    end
  end
  
  def random_string
    alphabet = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    loop do
      string = (0...50).map{ alphabet[rand(alphabet.length)] }.join
      (return string) if !TariffZone.all.map{|x| x.name}.include? string
    end
  end
  
  def destroy_tariff_zone
    if remove_tariff_zone.present?
      relationship = TariffZone.find(remove_tariff_zone).stations.select{|s| s.id!=self.id}
      TariffZone.delete(remove_tariff_zone) if relationship.empty?
    end
  end
  
  # Станция не должна принадлежать маршруту и выступать в качестве отправной или конечной станции
  def any_route?
    count = self.routes.select{|r| r.start_station_id == self.id || r.end_station_id == self.id}.size
    count > 0 ? errors.add(:base, :any_route) : (return true)
    false
  end
end
