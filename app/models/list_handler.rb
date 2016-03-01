class ListHandler
  def self.create_item(params)
    if params[:code]
      return add_item_to_list(params)
    else
      params[:code] = make_new_list
      return add_item_to_list
    end
  end

  def add_item_to_list(params)
    list_item = ListItem.new(params)
    if list_item.save
      return list_item
    else
      return list_item.errors.full_messages
    end
  end
end
