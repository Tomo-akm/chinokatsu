FactoryBot.define do
  factory :post do
    content { Faker::Lorem.paragraph }
    association :user

    trait :with_tags do
      after(:create) do |post|
        create_list(:tag, 3, posts: [ post ])
      end
    end
  end
end
