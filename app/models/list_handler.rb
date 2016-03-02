class ListHandler
  def self.attach_list(params)
    new_params = params.deep_dup
    list = List.find_by(code: new_params[:code])
    new_params.delete(:code)

    !list ? list = List.create(code: List.generate_code) : list = list

    new_params[:list_id] = list.id
    ListItem.new(new_params)
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
