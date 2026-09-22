class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :pizza

  validates :size, presence: true, inclusion: { in: -> (_) { PizzaConfig.size_keys } }

  def base_price
    pizza.base_price * size_multiplier
  end

  def extra_price
    extra_ingredients.sum do |ingredient|
      ingredient_price(ingredient) * size_multiplier
    end
  end

  def price
    base_price + extra_price
  end

  private

  def size_multiplier
    PizzaConfig.size_multipliers.fetch(size)
  end

  def ingredient_price(ingredient)
    PizzaConfig.ingredients.fetch(ingredient)
  end
end