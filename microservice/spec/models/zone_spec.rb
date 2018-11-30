require 'rails_helper'

describe Zone, type: :model do
  it 'instantiates' do
    expect { create(:zone) }.to change { Zone.count }.by(1)
  end

  context 'validations' do
    before { create(:zone) }
    [:title, :impressions].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end
    it { is_expected.to validate_uniqueness_of(:title) }
  end

  context 'relationships' do
    it { is_expected.to have_many(:ads).dependent(:restrict_with_exception) }
  end
end
