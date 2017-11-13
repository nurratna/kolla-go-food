FactoryGirl.define do
  factory :food do
    name { Faker::Food.dish }
    description { Faker::Food.ingredient }
    price 10000.0
    tag_ids {[]}
  end

  factory :invalid_food, parent: :food do
    name nil
    description nil
    price 1000.0
    tag_ids nil
  end
end
