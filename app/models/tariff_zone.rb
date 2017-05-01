class TariffZone < ActiveRecord::Base
  has_many :stations, dependent: :destroy
  validates :name, presence: true
end
