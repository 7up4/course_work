class RouteStation < ActiveRecord::Base
  belongs_to :station
  belongs_to :route

  validates :station, :route, presence: true

  accepts_nested_attributes_for :station, reject_if: :all_blank
end
