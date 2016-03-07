class ListHandler
  def self.attach_list(params)
    new_params = params.deep_dup
    todo_list = TodoList.find_by(code: params[:code])
    new_params.delete(:code)

    if !todo_list
      todo_list = TodoList.create(code: TodoList.generate_code)
    end
    new_params[:todo_list_id] = todo_list.id
    TodoItem.new(new_params)
  end

  def self.create_item(params)
      todo_item = attach_list(params)
      if todo_item.save
        todo_item.todo_list.items_changed
        TodoResponder.
         groom_response(code: 204,
                        resource: {todo_item: todo_item.as_json},
                        message: "Resource Created")
      else
        TodoResponder.
         groom_response(code: 422,
                        resource: {todo_item: nil},
                        message: todo_item.errors.full_messages.join(" "))
      end
  end

  def self.delete_item(id)
    todo_item = TodoItem.find_by(id: id)
    if todo_item
      todo_item.delete
      todo_item.todo_list.items_changed
      TodoResponder.
       groom_response(code: 204,
                      resource: {todo_item: todo_item.as_json},
                      message: "Resource Deleted")
    else
      TodoResponder.
        groom_response(code: 404,
                     resource: {todo_item: todo_item.as_json})
    end
  end


end
