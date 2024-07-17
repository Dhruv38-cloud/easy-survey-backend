FactoryBot.define do
  factory :survey do
    name { Faker::Lorem.sentence }
    association :user
  end
end
