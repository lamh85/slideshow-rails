class LocationsController < ApplicationController
  def show
    # Example:
    # /locations?longitude_degrees=6&longitude_minutes=15&longitude_direction=W&latitude_degrees=53&latitude_minutes=20&latitude_direction=N

    response = LocationsService::GetCity.call(params)
    render json: response
  end
end
