class AddUniqueIndexToOrdersSourceId < ActiveRecord::Migration[8.1]
  def change
    add_index :orders, :source_id, unique: true
  end
end
