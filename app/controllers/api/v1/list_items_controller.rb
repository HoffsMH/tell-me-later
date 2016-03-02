class Api::V1::ListItemsController < ApplicationController
  respond_to :json

  def create
    render json: ListHandler.create_item(list_item_params)
  end

  private
  def list_item_params
    params.require("list_item").permit(:list_id,
                                       :code,
                                       :title,
                                       :content,
                                       :show_time)
  end
end
