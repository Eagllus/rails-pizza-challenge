FactoryBot.define do
  factory :pizza do
    sequence(:name) { |n| "Pizza#{n}" }
    base_price { 6 }
  end
end