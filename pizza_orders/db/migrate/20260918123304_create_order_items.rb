class CreateOrderItems < ActiveRecord::Migration[8.1]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :pizza, null: false, foreign_key: true
      t.string :size, null: false
      t.json :extra_ingredients, null: false, default: []
      t.json :omitted_ingredients, null: false, default: []

      t.timestamps
    end
  end
end
