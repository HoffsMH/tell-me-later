class Adddefaultvalueforpriority < ActiveRecord::Migration
  def change
    change_column_default :list_items, :priority, 5
  end
end
