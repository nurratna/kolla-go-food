# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    username { Faker::Name.name }
    password 'asdf123456'
    password_confirmation 'asdf123456'
  end

  factory :invalid_user, parent: :user do
    username nil
    password nil
    password_confirmation nil
  end
end
