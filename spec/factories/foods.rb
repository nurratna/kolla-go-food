FactoryGirl.define do
  factory :food do
    name { Faker::Food.dish }
    # sequence :name do |n|
    #   "name#{n}"
    # end
    description { Faker::Food.ingredient }
    price 10000.0

    association :category
  end

  factory :invalid_food, parent: :food do
    name nil
    description nil
    price 1000.0
  end
end
