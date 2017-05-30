if (u1 = User.find_by_email('admin@localhost')).nil?
  u1 = User.create!(password: 'qwerty', password_confirmation: 'qwerty',
    email: 'admin@localhost')
  u1.activate!
end
if (u2 = User.find_by_email('user@localhost')).nil?
  u2 = User.create!(password: 'qwerty', password_confirmation: 'qwerty',
    email: 'user@localhost')
  u2.activate!
end
r1, r2 = Role.create_main_roles
ru1 = RoleUser.create(role: r1, user: u1)
ru2 = RoleUser.create(role: r2, user: u2)

RouteStation.delete_all
Route.delete_all
Station.delete_all
TariffZone.delete_all

tariff_zone_num=5
station_num=10
route_num=10

tariff_zone_num.times{|i| TariffZone.create!(name: "Tariff zone №" + (i+1).to_s)}

station_num.times do |i|
  Station.create!(
    name: "Station №"+(i+1).to_s,
    tariff_zone: TariffZone.all[(0...tariff_zone_num).to_a.shuffle[0]],
    number: i+1
  )
end

def random_hour
  (Date.today + rand(0..23).hour + rand(0..60).minutes).to_datetime
end

def random_bool
  [true, false].sample
end

route_num.times do |i|
  r=Route.create(
    mon: random_bool,
    tues: random_bool,
    wed: random_bool,
    thurs: random_bool,
    fri: random_bool,
    sat: random_bool,
    sun: random_bool
  )
  s = []
  station_num.times{s<<Station.all[(0...station_num).to_a.shuffle[0]]}
  s.uniq!
  r.stations<<s
  r.route_stations.each do |rs|
    rs.arrival_time = random_hour
    rs.is_missed = false
  end
  rs = r.route_stations.select{|k| !k.is_missed}.sort_by {|x| x[:arrival_time]}
  r.start_station_id=rs.first.station_id
  r.end_station_id=rs.last.station_id
  r.save
end
