FactoryGirl.define do
  factory :voucher do
    code "GOJEK"
    valid_from "2107-11-06"
    valid_through "2107-11-07"
    amount 15.0
    unit "Rupiah"
    max_amount 10000.0
  end

  factory :invalid_voucher, parent: :voucher do
    code nil
    valid_from nil
    valid_through nil
    amaount nil
    unit nil
    max_amount nil
  end
end
