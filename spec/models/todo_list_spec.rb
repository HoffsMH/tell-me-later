require 'rails_helper'

RSpec.describe TodoList, type: :model do
  it "exists" do
    expect(TodoList).not_to be_nil
  end
  describe "#items_changed" do
    before(:each) do
      @todo_list = TodoList.create(code: TodoList.generate_code,
                      last_changed: Time.now - 10 * 60 * 60)
    end
    it "changes last_changed to current time" do
      old_last_changed = @todo_list.last_changed
      sleep 1

      @todo_list.items_changed
      new_last_changed = @todo_list.last_changed


      expect(new_last_changed).not_to eq(old_last_changed)
    end
  end
end
