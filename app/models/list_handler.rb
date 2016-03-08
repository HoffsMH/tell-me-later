module ListHandler

  def self.authenticate(todo_item, code)
    todo_list =  TodoList.find_by(code: code)
    todo_list && todo_item.todo_list_id == todo_list.id
  end

  def self.find_or_create_list(code)
    # not using find_or_create_by here because
    # we dont want users to be able to create their own codes
    todo_list = TodoList.find_by(code: code)

    !todo_list ? todo_list = TodoList.generate.id : todo_list.id
  end

  def self.create_item(params)
    params[:todo_list_id] = find_or_create_list(params.delete(:code))
    todo_item = TodoItem.new(params)
    if todo_item.save
      todo_item.list_changed!
      TodoResponses.resource_created(todo_item)
    else
      TodoResponses.unprocessable_entity(todo_item)
    end
  end

  def self.delete_item(todo_item, params)
    code = params.delete(:code)
    if authenticate(todo_item, code) && todo_item.delete
      todo_item.list_changed!
      TodoResponses.resource_deleted(todo_item)
    else
      TodoResponses.resource_not_found(:todo_item)
    end
  end

  def self.update_item(todo_item, params)
    code = params.delete(:code)
    if authenticate(todo_item, code) && todo_item.update(params)
      todo_item.list_changed!
      TodoResponses.resource_updated(todo_item)
    elsif authenticate(todo_item, code) && todo_item
      TodoResponses.unprocessable_entity(todo_item)
    else
      TodoResponses.resource_not_found(:todo_item)
    end
  end
end
