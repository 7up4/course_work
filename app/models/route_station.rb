class RouteStation < ActiveRecord::Base
  attr_accessor :remove_station
  
  after_initialize :set_defaults
  after_destroy :destroy_station
  
  belongs_to :station
  belongs_to :route

  validates :station, :route, presence: true
  validates :is_missed, inclusion: {in: [true, false]}
  validate :not_missed?

  accepts_nested_attributes_for :station, reject_if: :all_blank

  protected

  def destroy_station
    if remove_station
      self.station.destroy
    end
  end
  
  def set_defaults
    self.is_missed ||= false
  end

  def not_missed?
    errors.add(:base, :station_not_missed) if !self.is_missed && self.arrival_time.blank?
  end
end
