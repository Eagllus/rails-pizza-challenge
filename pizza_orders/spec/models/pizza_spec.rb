require "rails_helper"

RSpec.describe Pizza, type: :model do
  it "is valid with a name and base_price" do
    pizza = build(:pizza, name: "Margherita", base_price: 5)
    expect(pizza).to be_valid
  end

  it "requires a name" do
    pizza = build(:pizza, name: nil)
    expect(pizza).not_to be_valid
  end

  it "requires a unique name" do
    create(:pizza, name: "Salami")
    duplicate = build(:pizza, name: "Salami")
    expect(duplicate).not_to be_valid
  end

  it "requires base_price to be greater than 0" do
    pizza = build(:pizza, base_price: 0)
    expect(pizza).not_to be_valid
  end
end