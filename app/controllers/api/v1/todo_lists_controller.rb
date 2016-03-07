class Api::V1::TodoListsController < ApplicationController
  respond_to :json

  def show
    todo_list = TodoList.find_by(code: todo_list_params)
    if todo_list
      output = TodoResponder
        .groom_response(code: 201, 
                        resource:
                          {todo_list: todo_list.todo_items.as_json})

      render json: output.as_json, status: 201
    else
      output = TodoResponder
        .groom_response(code: 404,
                        resource: nil,
                        message: "todo_list not found")

      render json: output, status: 404
    end
  end

  private
  def todo_list_params
    params.require("code")
  end
end
