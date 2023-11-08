require 'net/http'

module LocationsService
  class GetCity
    class << self
      attr_accessor :params

      def call(params)
        @params = params
        open_api_response
      end

      private

      def open_api_response
        api_key = ENV['OPEN_WEATHER_API_KEY']
        uri_string = "http://api.openweathermap.org/geo/1.0/reverse?lat=#{latitude}&lon=#{longtitude}&limit=5&appid=#{api_key}"
        uri = URI(uri_string)
        Net::HTTP.get(uri)
      end

      def longtitude
        degree_notation_to_degrees(params[:longtitude], params[:longtitudeDirection])
      end

      def latitude
        degree_notation_to_degrees(params[:latitude], params[:latitudeDirection])
      end

      def degree_notation_to_degrees(degree_notation, direction)
        degrees_minutes = degree_notation.split('°')
        degrees = degrees_minutes.first.to_i
        minutes = degrees_minutes.last.to_i
        scalar = degrees + minutes / 60.to_f

        multiplier = ['N', 'E'].include?(direction) ? 1 : -1
        scalar * multiplier
      end
    end
  end
end