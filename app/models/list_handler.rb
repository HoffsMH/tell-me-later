module ListHandler
  def self.find_or_create_list(code)
    # not using find_or_create_by here because
    # we dont want users to be able to create their own codes
    # since that would not be secure.
    todo_list = TodoList.find_by(code: code)

    !todo_list ? todo_list = TodoList.generate : todo_list
  end

  def self.convert_code_to_id(params)
    todo_list = find_or_create_list(params[:code])
    params[:todo_list_id] = todo_list.id
    params.delete(:code)
    params
  end

  def self.attach_list(params)
    params = convert_code_to_id(params)
    TodoItem.new(params)
  end

  def self.create_item(params)
      todo_item = attach_list(params)
      if todo_item.save
        todo_item.list_changed!
        TodoResponses.resource_created(todo_item)
      else
        TodoResponses.unprocessable_entity(todo_item)
      end
  end

  def self.delete_item(id)
    todo_item = TodoItem.find_by(id: id)
    if todo_item && todo_item.delete
      todo_item.list_changed!
      TodoResponses.resource_deleted(todo_item)
    else
      TodoResponses.resource_not_found(:todo_item)
    end
  end

  def self.update_item(id, params)
    params = convert_code_to_id(params)
    todo_item = TodoItem.find_by(id: id)
    if todo_item && todo_item.update(params)
      todo_item.list_changed!
      TodoResponses.resource_updated(todo_item)
    elsif todo_item
      TodoResponses.unprocessable_entity(todo_item)
    else
      TodoResponses.resource_not_found(:todo_item)
    end
  end
end
