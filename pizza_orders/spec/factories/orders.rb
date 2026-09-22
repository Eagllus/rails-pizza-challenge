FactoryBot.define do
  factory :order do
    sequence(:source_id) { |n| "order-#{n}" }
    state { :open }
    promotion_codes { [] }
    discount_code { nil }
  end
end