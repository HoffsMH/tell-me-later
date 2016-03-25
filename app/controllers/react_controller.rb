class ReactController < ApplicationController
  def show
    render "show", layout: "react"
  end
end
