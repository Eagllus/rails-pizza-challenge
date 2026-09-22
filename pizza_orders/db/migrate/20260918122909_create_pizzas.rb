class CreatePizzas < ActiveRecord::Migration[8.1]
  def change
    create_table :pizzas do |t|
      t.string :name
      t.decimal :base_price

      t.timestamps
    end
  end
end
