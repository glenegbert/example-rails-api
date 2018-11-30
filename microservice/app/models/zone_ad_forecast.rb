module ZoneAdForecast
  def self.forecast(zone_id, date)
    impressions = Zone.find(zone_id).impressions.to_f
    ads(zone_id, date).reduce([]) do |accum, ad|
      goal = daily_goal(ad)
      if impressions >= goal
        accum.push({ad_id: ad.id, percentage: 100.00})
      else
        percentage_available = ((impressions / goal) * 100.00).round(2)
        accum.push({ad_id: ad.id, percentage: percentage_available})
      end
      (impressions -= goal) > 0 ? nil : impressions = 0
      accum
    end
  end

  class << self

    def daily_goal(ad)
      ad.goal / (ad.start_date..ad.end_date).count
    end

    def ads(zone_id, date)
      as = Zone
        .find(zone_id)
        .ads
        .where("start_date <= ? AND end_date >= ?",
               Date.parse(date),
               Date.parse(date))
        .order(:priority)
    end
  end
end
