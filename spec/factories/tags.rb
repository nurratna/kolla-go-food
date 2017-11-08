# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tag do
    name { Faker::Food.dish }
    food_ids {[]}
  end

  factory :invalid_tag, parent: :tag do
    name nil
    food_ids nil
  end
end
