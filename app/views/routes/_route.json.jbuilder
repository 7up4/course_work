json.extract! route, :id, :start_station, :end_station, :created_at, :updated_at
json.url route_url(route, format: :json)
