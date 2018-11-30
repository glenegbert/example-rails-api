require 'rails_helper'
describe 'POST /zones' do
  let(:valid_attributes) { { title: 'Mountain', impressions: 1000 } }

  context 'when the request is valid' do
    it 'creates a zone' do
      expect { post '/zones', params: valid_attributes }
        .to change { Zone.count }.by(1)

      expect(json['title']).to eq('Mountain')
      expect(json['impressions']).to eq(1000)
    end

    it 'returns status code 201' do
      post '/zones', params: valid_attributes
      expect(response).to have_http_status(201)
    end
  end

  context 'when the request is invalid' do
    before { post '/zones', params: { title: 'Missing impressionsjk' } }

    it 'returns status code 422' do
      expect(response).to have_http_status(422)
    end

    it 'returns a validation failure message' do
      expect(response.body).to match(/Validation failed: Impressions can't be blank/)
    end
  end
end
