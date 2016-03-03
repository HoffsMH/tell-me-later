class CreateTodoItems < ActiveRecord::Migration
  def change
    create_table :todo_items do |t|
      t.references :todo_list, index: true, foreign_key: true

      t.integer :priority, default: 5
      t.text :title
      t.text :content
      t.datetime :show_time

      t.timestamps null: false
    end
  end
end
