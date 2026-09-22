# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_21_125106) do
  create_table "order_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.json "extra_ingredients", default: [], null: false
    t.json "omitted_ingredients", default: [], null: false
    t.integer "order_id", null: false
    t.integer "pizza_id", null: false
    t.string "size", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["pizza_id"], name: "index_order_items_on_pizza_id"
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "discount_code"
    t.json "promotion_codes", default: [], null: false
    t.string "source_id"
    t.integer "state", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["source_id"], name: "index_orders_on_source_id", unique: true
  end

  create_table "pizzas", force: :cascade do |t|
    t.decimal "base_price"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "pizzas"
end
