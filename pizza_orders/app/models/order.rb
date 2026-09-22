class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy

  enum :state, { open: 0, completed: 1 }

  validates :source_id, presence: true, uniqueness: true

  def total_price
    apply_discount(subtotal_after_promotions).round(2)
  end

  private

  def subtotal_after_promotions
    order_items.sum(&:price) - promotion_savings
  end

  def apply_discount(subtotal)
    return subtotal if discount_code.blank?

    percent = PizzaConfig.discounts.dig(discount_code, "deduction_in_percent")
    return subtotal unless percent

    subtotal - (subtotal * percent / 100)
  end

  def promotion_savings
    promotion_codes.uniq.sum { |code| savings_for(code) }
  end

  def savings_for(code)
    promo_code = PizzaConfig.promotions[code]
    return 0 unless promo_code

    matched = order_items.select do |item|
      item.pizza.name == promo_code["target"] && item.size == promo_code["target_size"]
    end
    return 0 if matched.empty?

    groups = matched.size / promo_code["from"]
    free_count = groups * (promo_code["from"] - promo_code["to"])

    matched.map(&:base_price).sort.first(free_count).sum
  end
end