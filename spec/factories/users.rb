FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    name { Faker::Name.name }
    favorite_language { %w[Ruby Python JavaScript Go].sample }
    research_lab { Faker::Company.name }
    internship_count { rand(0..10) }
    personal_message { Faker::Lorem.sentence }

    trait :without_profile do
      favorite_language { nil }
      research_lab { nil }
      internship_count { nil }
      personal_message { nil }
    end
  end
end
