require 'rails_helper'

RSpec.describe Api::V1::TodoListsController, type: :controller do
  describe 'GET #show' do
   context 'when given a code for a list that does exist' do
     let!(:code) {"this list does exist"}
     let!(:items_count) { 3 }
     before(:each) do
       def valid_params
         valid_params = {
           code: code,
           priority: 5,
           title: "valid title",
           content: "valid content",
           show_time: "Tue Mar 01 2016 15:20:18 GMT-0700 (MST)"
         }
         valid_params
       end
       list = TodoList.create(code: code)
       items_count.times do
         ListHandler.create_item(valid_params)
       end
     end

     it 'returns the corresponding list' do
       get :show, code: code
       body = JSON.parse(response.body, symbolize_names: true)

       expect(body).not_to be_nil
       expect(body[:data][:todo_list].count).to eq(items_count)
     end
   end
   context "when given a code for a todo_list that does not exist" do
     let!(:code) {"this todo_list does not exist"}
     it "returns an error message" do
       get :show, code: code
       body = JSON.parse(response.body, symbolize_names: true)

       expect(body[:message][:error]).to be_a(String)
     end
   end
 end
end
