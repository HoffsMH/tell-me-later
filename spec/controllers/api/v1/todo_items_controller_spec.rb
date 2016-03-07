require 'rails_helper'

RSpec.describe Api::V1::TodoItemsController, type: :controller do

  describe 'POST #create' do
    context 'when parameters are correct' do
      let!(:valid_todo_item) do
        {
          code: "valid todolist code",
          priority: 5,
          title: "valid title",
          content: "valid content",
          show_time: "Tue Mar 01 2016 15:20:18 GMT-0700 (MST)"
        }
      end

      context 'and no list exists for provided list id' do
        it 'creates a new list and returns json form of the new list item' do
          post :create, todo_item: valid_todo_item
          output = JSON.parse(response.body, symbolize_names: true)
          output[:data][:todo_item].keys.each do |key|
            if valid_todo_item[key] && (key != :show_time)
              expect(output[:data][:todo_item][key]).to eq(valid_todo_item[key])
            end
          end
        end

        it "matches the show date submitted" do
          post :create, todo_item: valid_todo_item
          output = JSON.parse(response.body, symbolize_names: true)
          input_date = DateTime.parse(valid_todo_item[:show_time])
          output_date = DateTime.parse(output[:data][:todo_item][:show_time])

          expect(output_date.utc).to eq(input_date.utc)
        end

        context "no default show-time is specified" do
          let!(:no_show_time) do
            {
              code: "valid list code",
              priority: 5,
              title: "valid title",
              content: "valid content"
            }
          end

          it "show time defaults to now(immeadiately)" do
            post :create, todo_item: no_show_time
            output = JSON.parse(response.body, symbolize_names: true)

            output_date = DateTime.parse(output[:data][:todo_item][:show_time]).utc
            .strftime("%A, %d %b %Y %l:%M %p")
            now = DateTime.now.utc
            .strftime("%A, %d %b %Y %l:%M %p")
            expect(output_date).to eq(now)
          end
        end



      end
    end
    context "when parameters are incorrect" do
      let!(:invalid_todo_item) do
        {
          priority: 5,
          show_time: "1/1/1987"
        }
      end

      it "returns an error message" do
        post :create, todo_item: invalid_todo_item
        output = JSON.parse(response.body, symbolize_names: true)
        expect(output[:status]).to eq (422)

        expect(output[:message][:error]).not_to be_nil
      end
    end
  end

  describe "DELETE #destroy" do
    context "when the todo_item exists" do
      before(:each) do
        @todo_list = TodoList.create(code: TodoList.generate_code)
        ListHandler.create_item(code: @todo_list.code,
                                title: "valid title",
                                content: "valid content")
        @todo_item = @todo_list.todo_items.first
      end
      it "it deletes the item" do
        delete :destroy, {todo_item: @todo_item.attributes}
        body = JSON.parse(response.body, symbolize_names: true)

        expect(@todo_list.todo_items.count).to eq(0)
        expect(TodoItem.find_by(id: @todo_item.id)).to be_nil
      end
    end
    context "when the todo_item does not exist" do
      before(:each) do
        @todo_list = TodoList.create(code: TodoList.generate_code)
        @todo_item = TodoItem.new(id: 2,
                                  title: "doesn't exist",
                                  content: "doesn't exist")
      end
      it "returns an error message" do
        delete :destroy, {todo_item: @todo_item.attributes}
        body = JSON.parse(response.body, symbolize_names: true)

        expect(body[:status]).to eq(404)
        expect(body[:message][:error]).not_to be_nil
      end
    end
  end
end
