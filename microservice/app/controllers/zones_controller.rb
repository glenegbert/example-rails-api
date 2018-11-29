class ZonesController < ApplicationController

  def create
    zone = Zone.create!(zone_params)
    json_response(zone, :created)
  end

  private

  def zone_params
    params.permit(:title, :impressions)
  end
end
