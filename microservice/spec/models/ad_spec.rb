require 'rails_helper'

RSpec.describe Ad, type: :model do
  it 'instantiates' do
    expect { create(:ad, zone: create(:zone)) }.to change { Ad.count }.by(1)
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:creative) }
    it { is_expected.to validate_presence_of(:priority) }
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:end_date) }
    it { is_expected.to validate_presence_of(:goal) }
  end

  context 'relationships' do
    it { is_expected.to belong_to(:zone) }
  end
end
