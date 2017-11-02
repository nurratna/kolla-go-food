# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    username { Faker::Name.name }
    password { Faker::Internet.password }
  end

  factory :invalid_user, parent: :user do
    username nil
    password nil
  end
end
