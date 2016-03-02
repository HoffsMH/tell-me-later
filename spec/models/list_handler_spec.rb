require 'rails_helper'

RSpec.describe ListHandler, type: :model do
  context "when given params that do not include a code" do
    let!(:params) do
      {
        title: "valid title",
        content: "valid content",
        show_time: "1/2/2017 12:34PM",
        priority: 5
      }
    end
    it "makes a new list and attaches the item to it" do
      old_list_count = List.all.count

      result = ListHandler.create_item(params)
      id = result[:list_item]["id"]
      list_item = ListItem.find_by(id: id)

      expect(list_item.list).not_to be_nil
      expect(List.all.count).to eq(old_list_count + 1 )
    end

  end

  context "when given params that include a code for a List that does not exist" do
    let!(:params) do
      {
        title: "valid title",
        content: "valid content",
        show_time: "1/2/2017 12:34PM",
        priority: 5,
        code: "this list does not exist"
      }
    end
    it "makes a new list with a new code and attaches the item to it" do
      old_list_count = List.all.count

      result = ListHandler.create_item(params)
      id = result[:list_item]["id"]
      list_item = ListItem.find_by(id: id)

      expect(list_item.list).not_to be_nil
      expect(List.all.count).to eq(old_list_count + 1 )
      expect(list_item.list.code).not_to eq("this list does not exist")
    end
  end

  context "when given params that include a code for a list that does exist" do
    let!(:params) do
      list = List.create(code: List.generate_code);
      {
        title: "valid title",
        content: "valissd content",
        show_time: "1/2/2017 12:34PM",
        priority: 5,
        code: list.code
      }
    end
    it "adds the item to the list" do
      old_params     = params.deep_dup
      old_list_count = List.all.count

      result = ListHandler.create_item(params)
      id = result[:list_item]["id"]
      list_item = ListItem.find_by(id: id)

      expect(list_item.list).not_to be_nil
      expect(List.all.count).to eq(old_list_count)
      expect(list_item.list.code).to eq(old_params[:code])
    end
  end

end
