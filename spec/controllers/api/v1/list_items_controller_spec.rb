require 'rails_helper'

RSpec.describe Api::V1::ListItemsController, type: :controller do

  describe 'POST #create' do
    context 'when parameters are correct' do
      let!(:valid_list_item) do
        {
          list_id:  'valid list id',
          priority: 5,
          title: "valid title",
          content: "valid content",
          show_time: "Tue Mar 01 2016 15:20:18 GMT-0700 (MST)"
        }
      end
      context 'and no list exists for provided list id' do
        it 'creates a new list and returns json form of the new list item' do
          post :create, valid_list_item
          # expect(response).to
          binding.pry
        end
      end
    end
  end
end
