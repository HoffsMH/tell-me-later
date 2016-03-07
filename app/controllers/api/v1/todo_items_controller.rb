class Api::V1::TodoItemsController < ApplicationController
  respond_to :json

  def create
    output = ListHandler.create_item(todo_item_params)
    render json: output, status: output[:status]
  end

  def destroy
    output = ListHandler.delete_item(todo_item_params[:id])
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
end
