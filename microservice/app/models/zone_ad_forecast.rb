module ZoneAdForecast
  def self.forecast(zone_id, date)
    available_impressions = Zone.find(zone_id).impressions.to_f
    ads(zone_id, date).each_with_object([]) do |ad, accum|
      add_to_report(available_impressions, ad, accum)
      next_impressions = available_impressions - daily_goal(ad)
      # keep available impressions from being negative so next calculations work
      available_impressions = next_impressions.positive? ? next_impressions : 0
    end
  end

  class << self
    def add_to_report(available_impressions, ad, report)
      percentage = percentage_available(available_impressions, ad)
      percentage = percentage > 100.00 ? 100.00 : percentage
      report.push(ad_id: ad.id, percentage: percentage)
    end

    def percentage_available(available_impressions, ad)
      ((available_impressions / daily_goal(ad)) * 100.00).round(2)
    end

    def daily_goal(ad)
      ad.goal / (ad.start_date..ad.end_date).count
    end

    def ads(zone_id, date)
      Zone
        .find(zone_id)
        .ads
        .where('start_date <= ? AND end_date >= ?',
               Date.parse(date),
               Date.parse(date))
        .order(priority: :desc)
    end
  end
end
