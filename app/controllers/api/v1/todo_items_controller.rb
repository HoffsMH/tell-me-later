class Api::V1::TodoItemsController < ApplicationController
  respond_to :json

  def create
    render json: ListHandler.create_item(todo_item_params)
  end

  private
  def todo_item_params
    params.require("todo_item").permit(:todo_list_id,
                                       :code,
                                       :title,
                                       :content,
                                       :show_time)
  end
end
