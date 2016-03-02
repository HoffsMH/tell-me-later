class ListHandler
  def self.attach_list(params)
    list = List.find_by(code: params[:code])
    params.delete(:code)

    !list ? list = List.create(code: List.generate_code) : list = list

    params[:list_id] = list.id
    ListItem.new(params)
  end

  def self.create_item(params)
      list_item = attach_list(params)
      if list_item.save
        {list_item: list_item.as_json}
      else
        {list_item: list_item.errors.full_messages}
      end
  end

end
