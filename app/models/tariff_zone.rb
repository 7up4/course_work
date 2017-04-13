class TariffZone < ActiveRecord::Base
  validates :name, presence: true
end
