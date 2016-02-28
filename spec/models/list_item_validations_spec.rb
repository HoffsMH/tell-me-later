require 'rails_helper'

RSpec.describe ListItem, type: :model do
  context "validations" do
    let!(:valid_attributes) do
      valid_list_attributes = {
        code: "valid code",
        item_count: 42,
        last_changed: "Sat, 27 Feb 2016 22:39:42 UTC +00:00"
      }
      list = List.create(valid_list_attributes)

      {
        list_id: list.id,
        priority: 1,
        title: "valid title",
        content: "super valid content",
        show_time: DateTime.now.utc
      }
    end

    it "is valid with valid attributes" do
      list_item = ListItem.new(valid_attributes)

      expect(list_item).to be_valid
    end

    it "is not valid without a list_id" do
      no_list_id = valid_attributes.deep_dup
      no_list_id.delete(:list_id)

      list_item = ListItem.new(no_list_id)

      expect(list_item).not_to be_valid
    end

    it "has a priority field that defaults to 5" do
      no_priority = valid_attributes.deep_dup
      no_priority.delete(:priority)

      list_item = ListItem.new(no_priority)

      expect(list_item.priority).to eq(5)
    end

    it "MUST have a title" do
      no_title = valid_attributes.deep_dup
      no_title.delete(:title)

      list_item = ListItem.new(no_title)

      expect(list_item).not_to be_valid
    end

    it "MUST have a content" do
      no_content = valid_attributes.deep_dup
      no_content.delete(:content)

      list_item = ListItem.new(no_content)

      expect(list_item).not_to be_valid
    end
  end
end
