require 'rails_helper'

RSpec.describe ListHandler, type: :model do
  describe ".create_item" do
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

        id = result[:data][:todo_item]["id"]
        todo_item = TodoItem.find_by(id: id)

        expect(todo_item.todo_list).not_to be_nil
        expect(TodoList.all.count).to eq(old_todo_list_count + 1)
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
        id = result[:data][:todo_item]["id"]
        todo_item = TodoItem.find_by(id: id)

        expect(todo_item.todo_list).not_to be_nil
        expect(TodoList.all.count).to eq(old_todo_list_count + 1 )
        expect(todo_item.todo_list.code).not_to eq("this todo_list does not exist")
      end
    end

    context "when given params that include a code for a todo_list that does exist" do
      before(:each) do
        @todo_list = TodoList.create(code: TodoList.generate_code);
        @params = {
          title: "valid title",
          content: "valid content",
          show_time: "1/2/2017 12:34PM",
          priority: 5,
          code: @todo_list.code
        }
      end

      it "adds the item to the todo_list" do
        old_count = @todo_list.todo_items.count

        ListHandler.create_item(@params)
        new_count = @todo_list.todo_items.count
        expect(new_count).to eq(old_count + 1)
      end
      it "updates last_changed field of the corresponding todo_list" do
        old_last_changed = @todo_list.last_changed
        sleep 2
        ListHandler.create_item(@params)

        new_last_changed = TodoList.find(@todo_list.id).last_changed

        expect(new_last_changed).not_to eq(old_last_changed)
      end
    end
  end

  describe ".delete_item" do
    context "when neither the todo_item nor the todo_list exists currently" do
      it "returns a 422 error " do
        result = ListHandler.delete_item(0) #doesn't exist

        expect(result[:status]).to eq(404)
        expect(result[:message][:error]).not_to be_nil
      end
    end
    context "when the todo_list exist but the todo_item is not found" do
      it "returns a 422 error " do
        result = ListHandler.delete_item(0) #doesn't exist

        expect(result[:status]).to eq(404)
        expect(result[:message][:error]).not_to be_nil
      end
    end
    context "when the todo_item is found and there are other todo_items on its list" do
      before(:each) do
        @todo_list = TodoList.create(code: TodoList.generate_code)
        params = {
          code: @todo_list.code,
          title: "valid Title",
          content: "valid content"
        }
        ListHandler.create_item(params)
        ListHandler.create_item(params)
      end
      it "responds with 204" do
        todo_item = @todo_list.todo_items.first
        result = ListHandler.delete_item(todo_item.id)

        expect(result[:status]).to eq(204)
        expect(result[:message][:success]).not_to be_nil
      end
      it "deletes the item" do
        old_item_count = TodoItem.all.count
        todo_item = @todo_list.todo_items.first
        result = ListHandler.delete_item(todo_item.id)

        expect(TodoItem.all.count).to eq(old_item_count - 1)
      end

    end
    context "when todo_item is found and it is the only todo_item on the list" do
      before(:each) do
        @todo_list = TodoList.create(code: TodoList.generate_code)
        params = {
          code: @todo_list.code,
          title: "valid Title",
          content: "valid content"
        }
        ListHandler.create_item(params)
      end
      it "responds with 204" do
        todo_item = @todo_list.todo_items.first
        result = ListHandler.delete_item(todo_item.id)

        expect(result[:status]).to eq(204)
        expect(result[:message][:success]).not_to be_nil
      end
      it "deletes the item" do
        old_item_count = TodoItem.all.count
        todo_item = @todo_list.todo_items.first
        result = ListHandler.delete_item(todo_item.id)

        expect(TodoItem.all.count).to eq(old_item_count - 1)
      end
      it "deletes the list" do
        old_item_count = TodoItem.all.count
        todo_item = @todo_list.todo_items.first
        result = ListHandler.delete_item(todo_item.id)

        expect(TodoList.find_by(id: @todo_list.id)).to be_nil
      end
    end
  end
  describe ".update_item" do
    context "when the item exist and the parameters are valid" do
      before(:each) do
        @todo_list = TodoList.create(code: TodoList.generate_code)
        params = {
          code: @todo_list.code,
          title: "valid Title",
          content: "valid content"
        }
        ListHandler.create_item(params)
        @todo_item = @todo_list.items.first

        def valid_params
          valid_params = {
            id: @todo_item.id,
            code: @todo_list.code,
            title: "new title",
            content: "new content",
            priority: 3
          }
          valid_params
        end
      end
      it "updates the item" do
        result = ListHandler.update_item(@todo_item.id, valid_params)

        updated_item = TodoItem.find_by(id: @todo_item.id)

        expect(updated_item.title).to eq("new title")
        expect(updated_item.content).to eq("new content")
        expect(updated_item.priority).to eq(3)
      end
    end
  end
end
