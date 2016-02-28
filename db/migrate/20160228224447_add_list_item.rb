class AddListItem < ActiveRecord::Migration
  def change
    create_table :list_items do |t|
      t.references :list, index: true, foreign_key: true

      t.integer :priority
      t.text :title
      t.text :content
      t.datetime :show_time

      t.timestamps null: false
    end
  end
end
