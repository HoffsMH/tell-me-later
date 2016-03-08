require 'rails_helper'

RSpec.describe ListHandler, type: :model do
  describe ".delete_item" do
    context "when provided invalid params" do
      before(:each) do
        @todo_list = TodoList.generate
        @wrong_todo_list = TodoList.generate
        @todo_item = TodoItem.create(
        title: "valid_title",
        content: "valid content",
        todo_list_id: @todo_list.id
        )
      end
      it "doesn't delete the item" do
        result = ListHandler.delete_item(@todo_item, {code: @wrong_todo_list.code})

        todo_list = TodoList.find_by(id: @todo_list.id)

        expect(todo_list.items).not_to be_empty
      end
      it "returns 404, and pretends that the todo_item doesn't exist" do
        result = ListHandler.delete_item(@todo_item, {code: @wrong_todo_list.code})

        expect(result[:status]).to eq(404)
        expect(result[:message][:error]).not_to be_nil
      end
    end
  end
  describe ".update_item" do
    context "when provided invalid params" do
      before(:each) do
        @todo_list = TodoList.generate
        @wrong_todo_list = TodoList.generate
        @todo_item = TodoItem.create(
        title: "valid_title",
        content: "valid content",
        todo_list_id: @todo_list.id
        )
        @invalid_parameters = {
          code: @wrong_todo_list.code,
          title: "edited title",
          content: "edited content"
        }
      end
      it "doesn't update the item" do
        result = ListHandler.update_item(@todo_item, @invalid_parameters)

        todo_item = TodoItem.find_by(id: @todo_item.id)

        expect(todo_item.title).not_to eq("edited title")
        expect(todo_item.content).not_to eq("edited content")
      end
      it "returns 404, and pretends that the todo_item doesn't exist" do
        result = ListHandler.update_item(@todo_item, {code: @wrong_todo_list.code})

        expect(result[:status]).to eq(404)
        expect(result[:message][:error]).not_to be_nil
      end
    end
  end
end
