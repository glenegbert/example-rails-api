class ReportsController < ApplicationController
  def create
    json_response(ZoneAdForecast.forecast(params[:zone_id], params[:date]), :created)
  end
end
