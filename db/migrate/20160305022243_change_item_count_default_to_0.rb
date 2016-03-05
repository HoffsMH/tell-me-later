class ChangeItemCountDefaultTo0 < ActiveRecord::Migration
  def change
    change_column_default(:todo_lists, :item_count, 0)
  end
end
