require 'net/http'

module LocationsService
  class GetCity
    class << self
      def call(params)
        # {"longtitude"=>"139°43", "longtitudeDirection"=>"E", "latitude"=>"35°43", "latitudeDirection"=>"N", "controller"=>"locations", "action"=>"show"}

        puts "class ==="
        puts params
      end

      private

      def open_api_response
        # http://api.openweathermap.org/geo/1.0/reverse?lat=${apiLat}&lon=${apiLon}&limit=5&appid=${process.env.OPEN_WEATHER_API_KEY}
        uri = URI()
      end

      def longtitude
        degree_notation_to_degrees(params[:longtitude], params[:longtitudeDirection])
      end

      def latitude
        degree_notation_to_degrees(params[:latitude], params[:latitudeDirection])
      end

      def degree_notation_to_degrees(degree_notation, direction)
        degrees_minutes = degree_notation.split('°')
        degrees = degrees_minutes.first
        minutes = degrees_minutes.last
        scalar = degrees + minutes / 60.to_f

        multiplier = ['N', 'E'].include?(direction) ? 1 : -1
        scalar * multiplier
      end
    end
  end
end