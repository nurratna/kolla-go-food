# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :review do
    name { Faker::Name.name }
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
  end

  factory :invalid_review, parent: :review do
    name nil
    title nil
    description nil
  end
end
