class LocationsController < ApplicationController
  def show
    LocationsService::GetCity.call(params)
    render json: { hello: 'world' }
  end
end
