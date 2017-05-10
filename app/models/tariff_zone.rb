class TariffZone < ActiveRecord::Base
  has_many :stations, dependent: :nullify
  validates :name, presence: true, uniqueness: true, length: {maximum: 64}
end
