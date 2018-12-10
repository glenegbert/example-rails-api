FactoryBot.define do
  factory :ad do
    creative { '<div>SomeHTML</div>' }
    sequence :priority do |n|
      n
    end
    start_date { '2018-11-29' }
    end_date { '2018-11-29' }
    goal { 1000 }
  end
end
