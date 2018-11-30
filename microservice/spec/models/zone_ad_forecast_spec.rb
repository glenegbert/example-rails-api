require "rails_helper"
describe ZoneAdForecast  do
  let(:zone) { create(:zone, impressions: 4000) }
  let(:date) { "2017-11-01" }

  def create_ad(priority:, goal:, id:)
    create(:ad, id: id,
           zone: zone,
           start_date: '2017-11-01',
           end_date: '2017-11-10',
           priority: priority,
           goal: goal)
  end

  it "creates a forecast" do
    create_ad(priority: 3, goal: 15000, id: 111)
    expect(described_class.forecast(zone.id, date))
      .to eq([{ad_id: 111, percentage: 100.0}])
  end

  it "orders the forcasts" do
    create_ad(priority: 8, goal: 15000, id: 111)
    create_ad(priority: 2 , goal: 15000, id: 112)
    expect(described_class.forecast(zone.id, date))
      .to eq([{ad_id: 112, percentage: 100.0},
              {ad_id: 111, percentage: 100.0}])
  end

  it "handles partial forcasts" do
    create_ad(priority: 2, goal: 15000, id: 111)
    create_ad(priority: 1, goal: 15000, id: 112)
    create_ad(priority: 3, goal: 15000, id: 113)
    expect(described_class.forecast(zone.id, date))
      .to eq([{ad_id: 112, percentage: 100.0},
              {ad_id: 111, percentage: 100.0},
              {ad_id: 113, percentage: 66.67}])
  end

  it "handles multiple forcasts of 0" do
    create_ad(priority: 2, goal: 15000, id: 111)
    create_ad(priority: 3, goal: 5000, id: 112)
    create_ad(priority: 1, goal: 80000, id: 113)
    expect(described_class.forecast(zone.id, date))
      .to eq([{ad_id: 113, percentage: 50.00},
              {ad_id: 111, percentage: 0.0},
              {ad_id: 112, percentage: 0.0}])
  end
end
