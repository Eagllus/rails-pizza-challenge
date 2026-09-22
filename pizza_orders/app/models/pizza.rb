class Pizza < ApplicationRecord
  has_many :order_items, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
  validates :base_price, presence: true, numericality: { greater_than: 0 }
end