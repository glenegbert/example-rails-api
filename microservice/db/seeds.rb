Ad.destroy_all
Zone.destroy_all

Zone.create!(id: 123, title: 'Test Zone', impressions: 5000)

creative = '<div>Ad</div>'
Ad.create!([
             { id: 111, creative: creative, zone_id: 123, start_date: '2017-12-01', end_date: '2017-12-10', priority: 8, goal: 15_000 },
             { id: 222, creative: creative, zone_id: 123, start_date: '2017-12-01', end_date: '2017-12-30', priority: 4, goal: 120_000 },
             { id: 333, creative: creative, zone_id: 123, start_date: '2017-12-10', end_date: '2017-12-14', priority: 6, goal: 10_000 },
             { id: 444, creative: creative, zone_id: 123, start_date: '2017-12-01', end_date: '2017-12-30', priority: 2, goal: 120_000 }
           ])
