require "rails_helper"

RSpec.describe OrderItem, type: :model do
  let(:pizza) { create(:pizza, name: "Salami", base_price: 6) }

  it "is valid with a known size" do
    item = build(:order_item, pizza: pizza, size: "Medium")
    expect(item).to be_valid
  end

  it "is invalid with an unknown size" do
    item = build(:order_item, pizza: pizza, size: "ExtraLarge")
    expect(item).not_to be_valid
  end

  describe "#base_price" do
    it "multiplies the pizza's base_price by the size multiplier" do
      item = build(:order_item, pizza: pizza, size: "Small")
      expect(item.base_price).to eq(4.2)
    end
  end

  describe "#extra_price" do
    it "is zero with no extras" do
      item = build(:order_item, pizza: pizza, size: "Medium")
      expect(item.extra_price).to eq(0)
    end

    it "sums extra ingredients at the size multiplier" do
      item = build(:order_item, pizza: pizza, size: "Medium", extra_ingredients: ["Onions", "Cheese"])
      expect(item.extra_price).to eq(3.0)
    end
  end

  describe "#price" do
    it "does not change price based on omitted ingredients" do
      with_omit = build(:order_item, pizza: pizza, size: "Medium", omitted_ingredients: ["Cheese"])
      without_omit = build(:order_item, pizza: pizza, size: "Medium")
      expect(with_omit.price).to eq(without_omit.price)
    end

    it "adds base_price and extra_price" do
      item = build(:order_item, pizza: pizza, size: "Large", extra_ingredients: ["Onions"])
      expect(item.price).to eq(item.base_price + item.extra_price)
    end
  end
end