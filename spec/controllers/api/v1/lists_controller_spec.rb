require 'rails_helper'

RSpec.describe Api::V1::ListsController, type: :controller do
  describe 'GET #show' do
    context 'when given a code for a list that does exist' do
      let!(:code) {"this list does exist"}
      let!(:valid_list_item) do
        {
          code: code,
          priority: 5,
          title: "valid title",
          content: "valid content",
          show_time: "Tue Mar 01 2016 15:20:18 GMT-0700 (MST)"
        }
      end
      let!(:items_count) { 3 }
      before(:each) do
        list = List.create(code: code)
        items_count.times do
          ListHandler.create_item(valid_list_item)
        end
      end
      it 'returns the corresponding list' do
        get :show, code: code
        body = JSON.parse(response.body, symbolize_names: true)

        expect(body).not_to be_nil
        expect(body[:list].count).to eq(items_count)
      end
    end
    context "when given a code for a list that does not exist" do
      let!(:code) {"this list does not exist"}
      it "returns an error message" do
        get :show, code: code
        body = JSON.parse(response.body, symbolize_names: true)

        expect(body[:list]).to be_a(String)
      end
    end
  end
end
