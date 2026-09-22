# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require "yaml"
require "json"

# Load Pizzas
config = YAML.load_file(Rails.root.join("../data/config.yml"))

config["pizzas"].each do |name, base_price|
  Pizza.find_or_create_by!(name: name) do |pizza|
    pizza.base_price = base_price
  end
end

# Load Orders
orders_data = JSON.parse(File.read(Rails.root.join("../data/orders.json")))

orders_data.each do |order_data|
  order = Order.find_or_initialize_by(source_id: order_data["id"])

  order.assign_attributes(
    state: order_data["state"].downcase,
    created_at: order_data["createdAt"],
    promotion_codes: order_data["promotionCodes"],
    discount_code: order_data["discountCode"]
  )
  order.save!

  order_data["items"].each do |item_data|
    pizza = Pizza.find_by!(name: item_data["name"])

    order.order_items.create!(
      pizza: pizza,
      size: item_data["size"],
      extra_ingredients: item_data["add"],
      omitted_ingredients: item_data["remove"]
    )
  end
end