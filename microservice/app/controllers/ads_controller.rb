class AdsController < ApplicationController
  def create
    ad = Ad.create!(ad_params.except(:start_date, :end_date).merge(formatted_dates))

    json_response(ad, :created)
  end

  private

  def formatted_dates
    puts "*******************"
    puts ad_params
    start_date = Date.parse(ad_params[:start_date])
    end_date = Date.parse(ad_params[:end_date])
    {start_date: start_date, end_date: end_date}
  end

  def ad_params
    params.permit(:creative, :priority, :start_date, :end_date, :goal, :zone_id)
  end
end
