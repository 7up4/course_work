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

TariffZone.delete_all
Station.delete_all
Route.delete_all
5.times{|i| TariffZone.create(name: "Tariff zone №" + (i+1).to_s)}
10.times do |i|
  s = Station.create(
    name: "Station №"+(i+1).to_s,
    tariff_zone: TariffZone.find(i/2+1)
  )
end
