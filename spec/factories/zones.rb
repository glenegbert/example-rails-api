FactoryBot.define do
  factory :zone do
    sequence :title do |n|
      "zone-#{n}"
    end
    impressions { 1000 }
  end
end
