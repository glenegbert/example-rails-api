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
      if ads_with_same_priority.count == 1
        ad = ads_with_same_priority[0]
        available = [daily_goal(ad), available_impressions].min
        ad_to_report(available, ad, report)
        available
      else
        min_assignment_amount =
          available_impressions / ads_with_same_priority.count
        sorted = ads_with_same_priority.sort { |ad| daily_goal(ad) }.reverse
        ad, *ads = sorted
        available = [daily_goal(ad), min_assignment_amount].min
        ad_to_report(available, ad, report)
        available + ads_to_report(available_impressions - available, ads, report)
      end
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
