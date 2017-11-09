# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :restaurant do
    name { Faker::Name.name }
    address { Faker::Address.street_address }
  end

  factory :invalid_restaurant, parent: :restaurant do
    name nil
    address nil
  end
end
