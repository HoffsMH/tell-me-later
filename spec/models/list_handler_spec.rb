require 'rails_helper'

RSpec.describe ListHandler, type: :model do
  describe "#create_item" do
    context "when given params that do not include a code" do
      let!(:params) do
        {
          title: "valid title",
          content: "valid content",
          show_time: "1/2/2017 12:34PM",
          priority: 5
        }
      end
      it "makes a new todo_list and attaches the item to it" do
        old_todo_list_count = TodoList.all.count

        result = ListHandler.create_item(params)
        id = result[:todo_item]["id"]
        todo_item = TodoItem.find_by(id: id)

        expect(todo_item.todo_list).not_to be_nil
        expect(TodoList.all.count).to eq(old_todo_list_count + 1 )
      end

    end

    context "when given params that include a code for a TodoList that does not exist" do
      let!(:params) do
        {
          title: "valid title",
          content: "valid content",
          show_time: "1/2/2017 12:34PM",
          priority: 5,
          code: "this todo_list does not exist"
        }
      end
      it "makes a new todo_list with a new code and attaches the item to it" do
        old_todo_list_count = TodoList.all.count

        result = ListHandler.create_item(params)
        id = result[:todo_item]["id"]
        todo_item = TodoItem.find_by(id: id)

        expect(todo_item.todo_list).not_to be_nil
        expect(TodoList.all.count).to eq(old_todo_list_count + 1 )
        expect(todo_item.todo_list.code).not_to eq("this todo_list does not exist")
      end
    end

    context "when given params that include a code for a todo_list that does exist" do
      let!(:params) do
        todo_list = TodoList.create(code: TodoList.generate_code);
        {
          title: "valid title",
          content: "valid content",
          show_time: "1/2/2017 12:34PM",
          priority: 5,
          code: todo_list.code
        }
      end
      it "adds the item to the todo_list" do
        old_params     = params.deep_dup
        old_todo_list_count = TodoList.all.count

        result = ListHandler.create_item(params)
        id = result[:todo_item]["id"]
        todo_item = TodoItem.find_by(id: id)

        expect(todo_item.todo_list).not_to be_nil
        expect(TodoList.all.count).to eq(old_todo_list_count)
        expect(todo_item.todo_list.code).to eq(old_params[:code])
      end
      it "updates the item_count and last_changed field of the corresponding todo_list" do
        old_params               = params.deep_dup
        old_todo_list_count      = TodoList.all.count
        old_item_count           = TodoList.first.item_count
        old_last_changed         = TodoList.first.last_changed


        result = ListHandler.create_item(params)
        id = result[:todo_item]["id"]
        todo_item = TodoItem.find_by(id: id)

        todo_list = todo_item.todo_list

        expect(todo_list.item_count).to eq(old_item_count + 1)
        expect(todo_list.last_changed).not_to eq(old_last_changed)
      end
    end
  end
end
