require 'rails_helper'

describe 'Post /reports' do
  let(:zone) { create(:zone) }
  let(:start_date)  { '2017-01-08' }

  context 'when the request is valid' do
    it 'gets a report' do
      3.times { create(:ad, zone: zone, start_date: start_date, end_date: '2017-1-10') }
      post '/reports', params: { zone_id: zone.id, date: start_date }
      expect(json.count).to eq(3)
      expect(json.first['ad_id']).to be_a(Integer)
      expect(json.first['percentage']).to be_a(Float)
    end

    it 'returns status code 201' do
      params = { zone_id: zone.id, date: start_date }
      post '/reports', params: { zone_id: zone.id, date: start_date }
      expect(response).to have_http_status(201)
    end
  end

  context 'when the request is invalid' do
    it 'returns status code 404 when invalid zone id' do
      post '/reports', params: { zone_id: 100, date: start_date }
      expect(response).to have_http_status(404)
    end

    it 'returns a validation failure message for missing id' do
      post '/reports', params: { date: start_date }
      expect(response.body).to match(/Couldn't find Zone without an ID/)
    end

    it 'returns a validation failure message for invalid date format' do
      post '/reports', params: { date: '1', zone_id: zone.id }
      expect(response.body).to match(/invalid date formatting/)
    end
  end
end
