class Api::V1::TodoListsController < ApplicationController
  respond_to :json

  def show
    todo_list = TodoList.find_by(code: todo_list_params)
    if todo_list
      render json: {todo_list: todo_list.todo_items.as_json}
    else
      render json: {todo_list: "todo_list not found"}
    end
  end

  private
  def todo_list_params
    params.require("code")
  end
end
