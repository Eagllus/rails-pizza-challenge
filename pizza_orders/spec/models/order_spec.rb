require "rails_helper"

RSpec.describe Order, type: :model do
  let(:salami) { create(:pizza, name: "Salami", base_price: 6) }
  let(:margherita) { create(:pizza, name: "Margherita", base_price: 5) }
  let(:tonno) { create(:pizza, name: "Tonno", base_price: 8) }

  describe "#total_price" do
    it "sums item prices with no codes applied" do
      order = create(:order)
      create(:order_item, order: order, pizza: tonno, size: "Large")

      expect(order.total_price).to eq(10.4) # 8 * 1.3
    end

    it "applies a discount code as a percentage off the subtotal" do
      order = create(:order, discount_code: "SAVE5")
      create(:order_item, order: order, pizza: salami, size: "Medium")

      expect(order.total_price).to eq(5.7) # 6 * 1.0 = 6; 5% off = 5.7
    end

    it "ignores an unknown discount code gracefully" do
      order = create(:order, discount_code: "EXTRA_DISCOUNT")
      create(:order_item, order: order, pizza: salami, size: "Medium")
      expect(order.total_price).to eq(6.0)
    end

    it "applies a 2-for-1 promotion once for exactly matching pairs" do
      order = create(:order, promotion_codes: ["2FOR1"])
      2.times { create(:order_item, order: order, pizza: salami, size: "Small") }

      expect(order.total_price).to eq(4.2) # 2 items at 6 * 0.7 = 4.2 each = 8.4 subtotal; one free -> 4.2
    end

    it "applies a 2-for-1 promotion multiple times for multiple qualifying groups" do
      order = create(:order, promotion_codes: ["2FOR1"])
      4.times { create(:order_item, order: order, pizza: salami, size: "Small") }

      expect(order.total_price).to eq(8.4) # 4 * 4.2 = 16.8 subtotal; 2 groups of 2 -> 8.4
    end

    it "still charges extras on a promoted pizza" do
      order = create(:order, promotion_codes: ["2FOR1"])
      create(:order_item, order: order, pizza: salami, size: "Small")
      create(:order_item, order: order, pizza: salami, size: "Small", extra_ingredients: ["Olives"])

      expect(order.total_price).to eq(5.95) # 4.2 + 4.2 = 8.4, one free (-4.2) = 4.2; extra Olives: 2.5*0.7=1.75 == 5.95
    end

    it "does not apply a promotion to non-matching items" do
      order = create(:order, promotion_codes: ["2FOR1"])
      create(:order_item, order: order, pizza: salami, size: "Large")
      expect(order.total_price).to eq(7.8)
    end

    it "matches order 3 from the sample data end-to-end" do
      order = create(:order, promotion_codes: ["2FOR1"], discount_code: "SAVE5")

      create(:order_item, order: order, pizza: salami, size: "Medium", extra_ingredients: ["Onions"], omitted_ingredients: ["Cheese"])
      create(:order_item, order: order, pizza: salami, size: "Small", extra_ingredients: ["Olives"])
      3.times { create(:order_item, order: order, pizza: salami, size: "Small") }

      # Medium +Onions -Cheese == 7.00
      # Small +Olives          == 5.95
      # Small (x3)             == 12.60
      # Subtotal: 7.00 + 12.60 + 5.95 = 25.55
      # Subtotal after promo: 25.55 - 8.40 = 17.15
      # total is 16.2925 == Rounded to 16.29
      expect(order.total_price).to eq(16.29)
    end
  end
end