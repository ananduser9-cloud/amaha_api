module Haversine
  EARTH_RADIUS_KM = 6371.0

  def self.distance(lat1, lon1, lat2, lon2)
    lat1_rad = to_rad(lat1)
    lat2_rad = to_rad(lat2)

    dlat = to_rad(lat2 - lat1)
    dlon = to_rad(lon2 - lon1)

    a = Math.sin(dlat / 2)**2 +
        Math.cos(lat1_rad) *
        Math.cos(lat2_rad) *
        Math.sin(dlon / 2)**2

    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

    EARTH_RADIUS_KM * c
  end

  def self.to_rad(deg)
    deg * Math::PI / 180
  end
end