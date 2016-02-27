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

  end

end
