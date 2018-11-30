require 'rails_helper'

describe 'POST /ads' do
  let(:zone) { create(:zone) }
  let(:valid_attributes) { { creative: '<div>Ad Copy</div>',
                             priority: 2,
                             start_date: "2018-11-22",
                             end_date: "2018-11-27",
                             goal: 4000,
                             zone_id: zone.id
                          } }


  context 'when the request is valid' do
    it 'creates an ad' do
      expect{ post '/ads.json', params: valid_attributes }
        .to change{ Ad.count }.by(1)
      expect(json['creative']).to eq('<div>Ad Copy</div>')
      expect(json['priority']).to eq(2)
      expect(json['start_date']).to eq("2018-11-22")
      expect(json['end_date']).to eq("2018-11-27")
      expect(json['goal']).to eq(4000)
      expect(json['zone_id']).to eq(zone.id)
    end

    it 'returns status code 201' do
      post '/ads', params: valid_attributes
      expect(response).to have_http_status(201)
    end
  end

  context 'when the request is invalid' do

    let(:attributes_missing_priority) {valid_attributes.except(:priority)}

    it 'returns status code 422' do
      post '/ads', params: attributes_missing_priority
      expect(response).to have_http_status(422)
    end

    it 'returns a validation failure message for missing attribute' do
      post '/ads', params: attributes_missing_priority
      expect(response.body).to match(/Validation failed: Priority can't be blank/)
    end

    it 'returns a validation failure message for invalid date format' do
      post '/ads', params: valid_attributes.except(:start_date).merge({start_date: "3"})
      expect(response.body).to match(/invalid date formatting/)
    end

  end
end
