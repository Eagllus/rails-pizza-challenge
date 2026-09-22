FactoryBot.define do
  factory :order_item do
    order
    pizza
    size { "Medium" }
    extra_ingredients { [] }
    omitted_ingredients { [] }
  end
end