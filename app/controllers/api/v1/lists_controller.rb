class Api::V1::ListsController < ApplicationController
  respond_to :json
  def index
    respond_with List.all
  end
end
