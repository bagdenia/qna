class Atm < ApplicationRecord
  validates :address, :lat, :lng, presence: true
  validates :lat, numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 }
  validates :lng, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  default_scope { order(created_at: :desc) }

  def self.get_closest(lat, lng)
    return [] if !lat || !lng || !((-90..90).cover? lat) || !((-180..180).cover? lng)
    Rails.cache.fetch("#{lat}_#{lng}/get_closet", expires_in: 12.hours) do
      Hash[self.all.map{ |e| [e, distance_between(lat, e.lat, lng, e.lng)] }].sort_by{ |k,v| v }.take(5)
    end
  end

  private

  def self.distance_between(lat1, lat2, lon1, lon2)
    rad_per_deg = Math::PI / 180
    rm = 6371000
    lat1_rad, lat2_rad = lat1 * rad_per_deg, lat2 * rad_per_deg
    lon1_rad, lon2_rad = lon1 * rad_per_deg, lon2 * rad_per_deg

    a = Math.sin((lat2_rad - lat1_rad) / 2) ** 2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin((lon2_rad - lon1_rad) / 2) ** 2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1 - a))

    (rm * c).round(0) # Delta in meters
  end
end

# (1..50).to_a.each{ |e| Atm.create(address: 'Addrs'+e.to_s, lat: rand(-90..90), lng: rand(-180..180)) }
