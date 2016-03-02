class Api::V1::ListsController < ApplicationController
  respond_to :json
  def index
    respond_with List.all
  end

  def show
    list = List.find_by(code: list_params)
    if list
      render json: {list: list.list_items.as_json}
    else
      render json: {list: "list not found"}
    end
  end

  private
  def list_params
    params.require("code")
  end
end
