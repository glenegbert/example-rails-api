module ZoneAdForecast
  def self.forecast(zone_id, date)
    zone = Zone.find(zone_id)
    available_impressions = zone.impressions.to_f
    ads = ads(zone,date).group_by(&:priority)
    ads.values.each_with_object([]) do |ads, accum|
      daily_assigned = ads_to_report(available_impressions, ads, accum)
      next_impressions = available_impressions - daily_assigned
      # keep available impressions from being negative so next calculations work
      available_impressions = next_impressions.positive? ? next_impressions : 0
    end
  end

  class << self
    def ad_to_report(available_impressions, ad, report)
      percentage = percentage_available(available_impressions, ad)
      percentage = (percentage > 100.00 || ad.goal == 0) ? 100.00 : percentage
      report.push(ad_id: ad.id, percentage: percentage)
    end

    def ads_to_report(available_impressions, ads_with_same_prio, report)
      total_used = 0
      total_daily_demand = ads_with_same_prio.map{|ad| daily_goal(ad) }.sum
      if (total_daily_demand <=  available_impressions) || available_impressions == 0
        ads_with_same_prio.each { |ad| ad_to_report(available_impressions/ads_with_same_prio.count, ad, report) }
        total_daily_demand
      else
        if ads_with_same_prio.count == 1
          ad_to_report(available_impressions, ads_with_same_prio[0], report)
          available_impressions
        else
          min_assignment_amount = available_impressions / ads_with_same_prio.count
          sorted = ads_with_same_prio.sort { |ad| daily_goal(ad) }.reverse
          ad, *ads= sorted
          available = (min_assignment_amount > daily_goal(ad)) ? daily_goal(ad) : min_assignment_amount
          ad_to_report(available, ad, report)
          available + ads_to_report(available_impressions - available, ads, report)
        end
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
