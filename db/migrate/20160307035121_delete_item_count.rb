class DeleteItemCount < ActiveRecord::Migration
  def change
    remove_column :todo_lists, :item_count
  end
end
