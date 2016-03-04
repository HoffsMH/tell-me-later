class ListHandler
  def self.attach_list(params)
    new_params = params.deep_dup
    todo_list = TodoList.find_by(code: new_params[:code])
    new_params.delete(:code)

    !todo_list ? todo_list = TodoList.create(code: TodoList.generate_code) : todo_list = todo_list

    new_params[:todo_list_id] = todo_list.id
    TodoItem.new(new_params)
  end

  def self.create_item(params)
      todo_item = attach_list(params)
      if todo_item.save
        {todo_item: todo_item.as_json}
      else
        {todo_item: todo_item.errors.full_messages}
      end
  end

end
