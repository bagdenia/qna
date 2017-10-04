# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
case Rails.env
when "development"
  (1..50).to_a.each{ |e| Atm.create(address: 'Addrs' + e.to_s, lat: rand(-90..90), lng: rand(-180..180)) }
end
