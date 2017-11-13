FactoryGirl.define do
  factory :role do
    rolename 'administrator'
  end

  factory :invalid_role, parent: :role do
    rolename nil
  end
end
