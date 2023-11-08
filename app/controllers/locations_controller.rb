class LocationsController < ApplicationController
  def show
    response = LocationsService::GetCity.call(params)
    render json: response
  end
end
