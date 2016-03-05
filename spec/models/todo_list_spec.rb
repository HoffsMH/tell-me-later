require 'rails_helper'

RSpec.describe TodoList, type: :model do
  it "exists" do
    expect(TodoList).not_to be_nil
  end
  describe "#item_added" do
    let!(:todo_list) do
      TodoList.create(code: TodoList.generate_code,
                      item_count: 3,
                      last_changed: Time.now - 10 * 60 * 60)
    end
    it "increments item_count by 1" do
      old_item_count = todo_list.item_count

      todo_list.item_added
      expect(todo_list.item_count).to eq(old_item_count + 1)
    end
    it "changes last_changed current time" do
      old_last_changed = todo_list.last_changed

      todo_list.item_added
      expect(todo_list.last_changed).not_to eq(old_last_changed)
    end
  end
end
