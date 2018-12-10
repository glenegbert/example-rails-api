require 'rails_helper'

RSpec.describe Ad, type: :model do
  it 'instantiates' do
    expect { create(:ad, zone: create(:zone)) }.to change { Ad.count }.by(1)
  end

  context 'validations' do
    [:creative, :priority, :start_date, :end_date, :goal].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end
  end

  context 'relationships' do
    it { is_expected.to belong_to(:zone) }
  end
end
