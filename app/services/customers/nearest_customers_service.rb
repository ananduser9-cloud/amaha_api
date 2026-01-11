module Customers
  class NearestCustomersService
    OFFICE_LAT  = 19.0590317
    OFFICE_LONG = 72.7553452
    MAX_DISTANCE_KM = 100

    Result = Struct.new(:customers, :invalid_lines)

    def initialize(file)
      @file = file
    end

    def call
      invalid_lines, customers = [], []

      @file.tempfile.read.each_line.with_index(1) do |line, idx|
        begin
          customer = JSON.parse(line)

          lat = customer["lat"]
          long = customer["long"]

          next unless lat.is_a?(Numeric) && long.is_a?(Numeric)

          distance = Haversine.distance(
              OFFICE_LAT,
              OFFICE_LONG,
              customer["lat"],
              customer["long"]
            )

          customers << { "id" => customer["id"], "name" => customer["name"] } if distance <= MAX_DISTANCE_KM
        rescue JSON::ParserError, TypeError
          invalid_lines << idx
        end
      end
      sorted_customers = customers.sort_by{ |customer| customer["id"] }
      Result.new(sorted_customers, invalid_lines)
    end
  end
end
