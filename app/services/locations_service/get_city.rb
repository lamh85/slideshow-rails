require 'net/http'

module LocationsService
  class GetCity
    class << self
      attr_accessor :params

      TOKYO_WARDS = %w(Adachi Arakawa Bunkyō Chiyoda Chūō Edogawa Itabashi Katsushika Kita Kōtō Meguro Minato Nakano Nerima Ōta Setagaya Shibuya Shinagawa Shinjuku Suginami Sumida Taitō Toshima)

      def call(params)
        @params = params
        open_weather_response(params)
      end

      private

      def open_weather_response(params)
        latitude = degree_notation(:latitude)
        longitude = degree_notation(:longitude)

        api_key = ENV['OPEN_WEATHER_API_KEY']
        uri_string = "http://api.openweathermap.org/geo/1.0/reverse?lat=#{latitude}&lon=#{longitude}&limit=5&appid=#{api_key}"
        uri = URI(uri_string)
        res_body = JSON.parse(Net::HTTP.get(uri))
        
        result = res_body[0]
        city_result = city_result(result['name'])
        {
          city: city_result[:city],
          city_subdivision_type: city_result[:city_subdivision_type],
          city_subdivision_name: city_result[:city_subdivision_name],
          country: result['country']
        }
      end

      def degree_notation(dimension)
        if (dimension == :longitude)
          degrees = params[:longitude_degrees]
          minutes = params[:longitude_minutes]
          direction = params[:longitude_direction]
        else
          degrees = params[:latitude_degrees]
          minutes = params[:latitude_minutes]
          direction = params[:latitude_direction]
        end

        scalar = degrees.to_f + minutes.to_f / 60
        multiplier = ['N', 'E'].include?(direction) ? 1 : -1
        scalar * multiplier
      end

      def city_result(unvalidated_city)
        if TOKYO_WARDS.include?(unvalidated_city)
          validated_city = 'Tokyo'
          city_subdivision_type = 'ward'
          city_subdivision_name = unvalidated_city
        else
          validated_city = unvalidated_city
          city_subdivision_type = nil
          city_subdivision_name = nil
        end

        {
          city: validated_city,
          city_subdivision_type: city_subdivision_type,
          city_subdivision_name: city_subdivision_name
        }
      end
    end
  end
end