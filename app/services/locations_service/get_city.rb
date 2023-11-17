require 'net/http'

module LocationsService
  class GetCity
    class << self
      attr_accessor :params,
                    :latitude_degrees,
                    :latitude_minutes,
                    :longitude_degrees,
                    :longitude_minutes,
                    :internal_result,
                    :open_weather_response

      # TODO: typo: "longtitude"
      # @params
      #  { latitude: String, longtitude: String, longtitudeDirection: 'W' | 'E', latitudeDirection: 'N' | 'S' }
      #  Both dimensions use degrees notation. EG: "80°33"
      # @return { city: String, country: String }
      def call(params)
        @params = params
        granularize_params
        result
      end

      private

      def granularize_params
        latitude, longtitude = params.values_at(:latitude, :longtitude)

        @latitude_degrees, @latitude_minutes = dimension_degrees_minutes(latitude).values_at(:degrees, :minutes)
        @longtitude_degrees, @longtitude_minutes = dimension_degrees_minutes(longtitude).values_at(:degrees, :minutes)
      end

      def dimension_degrees_minutes(degree_notation)
        split = degree_notation.split('°')
        {
          degrees: split.first,
          minutes: split.last
        }
      end

      def result
        return internal_result if internal_result
        external_result
      end

      def internal_result
        @internal_result ||= (
          location = Location.find_by(
            longitude_degrees: longtitude_degrees,
            longitude_minutes: longtitude_minutes,
            longitude_direction: params[:longtitudeDirection],
            latitude_degrees: latitude_degrees,
            latitude_minutes: latitude_minutes,
            latitude_direction: params[:latitudeDirection],
          )

          return nil unless location
          { city: location.city, country: location.country }
        )
      end

      def external_result
        get_open_weather
        save_response
        open_weather_response
      end

      def get_open_weather
        @open_weather_response ||= (
          longitude = degree_notation('longitude')
          latitude = degree_notation('latitude')
          api_key = ENV['OPEN_WEATHER_API_KEY']

          uri_string = "http://api.openweathermap.org/geo/1.0/reverse?lat=#{latitude}&lon=#{longitude}&limit=5&appid=#{api_key}"
          uri = URI(uri_string)
          response = Net::HTTP.get(uri) || []
          response[0]
        )
      end

      def save_response
        begin
          Location.create(
            longitude_degrees: longtitude_degrees,
            longitude_minutes: longtitude_minutes,
            longitude_direction: params[:longtitudeDirection],
            latitude_degrees: latitude_degrees,
            latitude_minutes: latitude_minutes,
            latitude_direction: params[:latitudeDirection],
            city: open_weather_response[:name],
            country: open_weather_response[:country]
          )
        rescue => error
          puts error
        end
      end

      # @params String: 'longitude' | 'latitude'
      def degree_notation(dimension)
        if dimension == 'longitude'
          degrees = longtitude_degrees
          minutes = longtitude_minutes
          direction = params[:longtitudeDirection]
        else
          degrees = latitude_degrees
          minutes = latitude_minutes
          direction = params[:latitudeDirection]
        end

        scalar = degrees + minutes / 60.to_f
        multiplier = ['N', 'E'].include?(direction) ? 1 : -1

        scalar * multiplier
      end
    end
  end
end