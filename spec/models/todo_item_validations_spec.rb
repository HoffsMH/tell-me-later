require 'rails_helper'

RSpec.describe TodoItem, type: :model do
  context "validations" do
    let!(:valid_attributes) do
      valid_list_attributes = {
        code: "valid code",
        item_count: 42,
        last_changed: "Sat, 27 Feb 2016 22:39:42 UTC +00:00"
      }
      todo_list = TodoList.create(valid_list_attributes)

      {
        todo_list_id: todo_list.id,
        priority: 1,
        title: "valid title",
        content: "super valid content",
        show_time: DateTime.now.utc
      }
    end

    it "is valid with valid attributes" do
      todo_item = TodoItem.new(valid_attributes)

      expect(todo_item).to be_valid
    end

    it "is not valid without a todo_list_id" do
      no_list_id = valid_attributes.deep_dup
      no_list_id.delete(:todo_list_id)

      todo_item = TodoItem.new(no_list_id)

      expect(todo_item).not_to be_valid
    end

    it "has a priority field that defaults to 5" do
      no_priority = valid_attributes.deep_dup
      no_priority.delete(:priority)

      todo_item = TodoItem.new(no_priority)

      expect(todo_item.priority).to eq(5)
    end

    it "MUST have a title" do
      no_title = valid_attributes.deep_dup
      no_title.delete(:title)

      todo_item = TodoItem.new(no_title)

      expect(todo_item).not_to be_valid
    end

    it "MUST have a content" do
      no_content = valid_attributes.deep_dup
      no_content.delete(:content)

      todo_item = TodoItem.new(no_content)

      expect(todo_item).not_to be_valid
    end

    it "has a show_time field that defaults to now" do
      no_show_time = valid_attributes.deep_dup
      no_show_time.delete(:show_time)

      todo_item = TodoItem.create(no_show_time)

      todo_item_show_time = todo_item
      .show_time
      .strftime("%A, %d %b %Y %l:%M %p")

      now = DateTime.now.utc
      .strftime("%A, %d %b %Y %l:%M %p")

      expect(todo_item_show_time).to eq(now)
    end
  end
end
