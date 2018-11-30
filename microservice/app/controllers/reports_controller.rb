class ReportsController < ApplicationController
  def create
    with_date_check do
      json_response(ZoneAdForecast.forecast(params[:zone_id], params[:date]), :created)
    end
  end

end
