class Api::V1::TodoItemsController < ApplicationController
  respond_to :json

  def create
    output = ListHandler.create_item(todo_item_params)
    render json: output, status: output[:status]
  end

  def destroy
    todo_item = TodoItem.find_by(id: id)
    output = ListHandler.delete_item(todo_item, todo_item_params)
    render json: output, status: output[:status]
  end

  def update
    todo_item = TodoItem.find_by(id: id)
    output = ListHandler.update_item(todo_item, todo_item_params)
    render json: output, status: output[:status]
  end

  private
  def todo_item_params
    params.require("todo_item").permit(:id,
                                       :code,
                                       :title,
                                       :content,
                                       :show_time)
  end
  def id
    params.require("id")
  end
end
