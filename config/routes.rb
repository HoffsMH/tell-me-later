Rails.application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      get '/lists', to: 'lists#index'
      post '/list_items', to: 'list_items#create'
    end
  end
end
