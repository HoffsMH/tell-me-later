require 'rails_helper'

RSpec.describe TodoList, type: :model do
  context "validations" do
   let!(:valid_attributes) do
     {
       code: "valid code",
       item_count: 42,
       last_changed: "Sat, 27 Feb 2016 22:39:42 UTC +00:00"
     }
   end

   it "is valid with valid attributes" do
     todo_list = TodoList.new(valid_attributes)

     expect(todo_list).to be_valid
   end

   it "is not valid without a code" do
     no_code = valid_attributes
     no_code[:code] = nil

     todo_list = TodoList.new(no_code)

     expect(todo_list).not_to be_valid
   end
   it "is not valid without a UNIQUE code" do
      non_unique_code = valid_attributes
      non_unique_code[:code] = "not unique!"

      todo_list1 = TodoList.create(non_unique_code)
      todo_list2 = TodoList.new(non_unique_code)

      expect(todo_list2).not_to be_valid
    end

    it "defaults to item_count as 1" do
      no_item_count = valid_attributes
      no_item_count.delete(:item_count)

      list = TodoList.create(no_item_count)

      expect(list.item_count).to eq(1)
    end

    it "does not require a last_changed date " do
      no_last_changed = valid_attributes.deep_dup
      no_last_changed.delete(:last_changed)

      todo_list1 = TodoList.create(no_last_changed)

      expect(todo_list1).to be_valid
    end

    it "can still set last_changed if needed" do
      todo_list1 = TodoList.create(valid_attributes)

      expect(todo_list1.last_changed).to eq(valid_attributes[:last_changed])
    end

    it "defaults to last changed as the current date" do
      no_last_changed = valid_attributes.deep_dup
      no_last_changed.delete(:last_changed)

      todo_list1 = TodoList.create(no_last_changed)
      todo_list1_time = todo_list1.last_changed.strftime("%A, %d %b %Y %l:%M %p")
      now = DateTime.now.utc.strftime("%A, %d %b %Y %l:%M %p")

      expect(todo_list1_time).to eq(now)
    end
 end
end
