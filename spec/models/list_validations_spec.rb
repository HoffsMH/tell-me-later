require 'rails_helper'

RSpec.describe List, type: :model do

  context "validations" do
    let!(:valid_attributes) do
      {
        code: "valid code",
        item_count: 42,
        last_changed: "Sat, 27 Feb 2016 22:39:42 UTC +00:00"
      }
    end

    it "is valid with valid attributes" do
      list = List.new(valid_attributes)

      expect(list).to be_valid
    end

    it "is not valid without a code" do
      no_code = valid_attributes
      no_code[:code] = nil

      list = List.new(no_code)

      expect(list).not_to be_valid
    end

    it "is not valid without a UNIQUE code" do
      non_unique_code = valid_attributes
      non_unique_code[:code] = "not unique!"

      list1 = List.create(non_unique_code)
      list2 = List.new(non_unique_code)

      expect(list2).not_to be_valid
    end

    it "defaults to item_count as 1" do
      no_item_count = valid_attributes
      no_item_count.delete(:item_count)

      list = List.create(no_item_count)

      expect(list.item_count).to eq(1)
    end

    it "does not require a last_changed date " do
      no_last_changed = valid_attributes.deep_dup
      no_last_changed.delete(:last_changed)

      list1 = List.create(no_last_changed)

      expect(list1).to be_valid
    end

    it "can still set last_changed if needed" do
      list1 = List.create(valid_attributes)

      expect(list1.last_changed).to eq(valid_attributes[:last_changed])
    end

    it "defaults to last changed as the current date" do
      no_last_changed = valid_attributes.deep_dup
      no_last_changed.delete(:last_changed)

      list1 = List.create(no_last_changed)
      list1_time = list1.last_changed.strftime("%A, %d %b %Y %l:%M %p")
      now = DateTime.now.utc.strftime("%A, %d %b %Y %l:%M %p")

      expect(list1_time).to eq(now)
    end

  end

end
