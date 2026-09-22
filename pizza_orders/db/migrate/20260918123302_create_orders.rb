class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.string  :source_id
      t.integer :state, null: false, default: 0
      t.json  :promotion_codes, null: false, default: []
      t.string  :discount_code

      t.timestamps
    end
  end
end
