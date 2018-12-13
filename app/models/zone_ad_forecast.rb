module ZoneAdForecast
  def self.forecast(zone_id, date)
    zone = Zone.find(zone_id)
    available_impressions = zone.impressions.to_f
    grouped_ads = ads(zone, date).group_by(&:priority)
    grouped_ads.values.each_with_object([]) do |ads, accum|
      daily_assigned = ads_to_report(available_impressions, ads, accum)
      next_impressions = available_impressions - daily_assigned
      # keep available impressions from being negative so next calculations work
      available_impressions = next_impressions.positive? ? next_impressions : 0
    end
  end

  class << self
    def ad_to_report(available_impressions, ad, report)
      percentage = percentage_available(available_impressions, ad)
      percentage = percentage > 100.00 || ad.goal.zero? ? 100.00 : percentage
      report.push(ad_id: ad.id, percentage: percentage)
    end

    def ads_to_report(available_impressions, ads_with_same_priority, report)
      used = 0
      ads_with_same_priority
          .sort { |ad| daily_goal(ad) }
          .reverse
          .each_with_index do |ad, index|
            remaining = ads_with_same_priority[index..-1]
            available = [ daily_goal(ad), (available_impressions-used)/remaining.count ].min
            ad_to_report(available, ad, report)
            used = used + available
          end
      used
    end

    def percentage_available(available_impressions, ad)
      ((available_impressions / daily_goal(ad)) * 100.00).round(2)
    end

    def daily_goal(ad)
      ad.goal / (ad.start_date..ad.end_date).count
    end

    def ads(zone, date)
      date = Date.parse(date)
      zone
        .ads
        .where('start_date <= ? AND end_date >= ?',
               date,
               date)
        .order(priority: :desc)
    end
  end
end
