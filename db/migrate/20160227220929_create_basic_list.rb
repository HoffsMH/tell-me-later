class CreateBasicList < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :code, index: true

      t.integer :item_count, default: 1
      t.datetime :last_changed

      t.timestamps null: false
    end
  end
end
