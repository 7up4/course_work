class RouteStation < ActiveRecord::Base
  belongs_to :station
  belongs_to :route

  validates :station, :route, presence: true
  validates :station, uniqueness: {scope: :route, message: "one station per route" }

  accepts_nested_attributes_for :station, reject_if: :all_blank
end
