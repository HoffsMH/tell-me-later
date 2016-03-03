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
            output[:todo_item].keys.each do |key|
              if valid_todo_item[key] && (key != :show_time)
                expect(output[:todo_item][key]).to eq(valid_todo_item[key])
              end
            end
          end

          it "matches the show date submitted" do
            post :create, todo_item: valid_todo_item
            output = JSON.parse(response.body, symbolize_names: true)
            input_date = DateTime.parse(valid_todo_item[:show_time])
            output_date = DateTime.parse(output[:todo_item][:show_time])

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

              output_date = DateTime.parse(output[:todo_item][:show_time]).utc
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

        it "returns an error message in place of the resulting item" do
          post :create, todo_item: invalid_todo_item
          output = JSON.parse(response.body, symbolize_names: true)[:todo_item]
          output.each do |message|
            expect(message).to be_a(String)
            expect(message).to include("can't")
          end
        end
      end
    end
end
